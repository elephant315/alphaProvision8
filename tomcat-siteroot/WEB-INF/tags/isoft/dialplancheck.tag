<%@ tag pageEncoding="UTF-8" %>
<%  request.setCharacterEncoding("UTF-8"); %>
<%  response.setCharacterEncoding("UTF-8"); %>
<%@ attribute name="value" required="true" %>
<%@ attribute name="validExtensions" required="true" %>
<%@ attribute name="var" rtexprvalue="false" required="true" %>
<%@ variable name-from-attribute="var" alias="current" variable-class="java.lang.String" scope="AT_END" %> 


<%@ tag import="java.util.Set"%>
<%@ tag import="java.util.HashSet"%>
<%@ tag import="java.util.Arrays"%>
<%@ tag import="java.util.regex.Matcher"%>
<%@ tag import="java.util.regex.Pattern"%>
<%@ tag import="java.io.StringReader"%>
<%@ tag import="java.io.BufferedReader"%>
<%@ tag import="java.lang.StringBuffer"%>
<%@ tag import="org.apache.commons.lang3.StringUtils"%>
<%@ tag import="org.apache.commons.lang3.ArrayUtils"%>

<%!
// online regex pattern matcher: http://www.regexplanet.com/advanced/java/index.html

// ^7[12]\d\d\d\d\d\d\d\d$
static Pattern kazakhPhoneNumberPattern = Pattern.compile("^7[12]\\d\\d\\d\\d\\d\\d\\d\\d$");

// ^\s*exten\s*=>\s*(.*?)\s*,\s*(.*?)\s*,\s*(.*)\s*$
static Pattern extenPattern = Pattern.compile("^\\s*exten\\s*=>\\s*(.*?)\\s*,\\s*(.*?)\\s*,\\s*(.*)\\s*$");

// ^(\w+)\((.*)\)$
static Pattern applicationPattern = Pattern.compile("^(\\w+)\\((.*)\\)$");

// ^\s*same\s*=>\s*(.*?)\s*,\s*(.*)\s*$
static Pattern samePattern = Pattern.compile("^\\s*same\\s*=>\\s*(.*?)\\s*,\\s*(.*)\\s*$");

// ^\s*;.*$
static Pattern commentPattern = Pattern.compile("^\\s*;.*$");

// ^\[(\S.*)\]$
static Pattern contextPattern = Pattern.compile("^\\[(\\S.*)\\]$");

static Set<String> allowedApplicationNames = new HashSet<String>(Arrays.asList(
                                                                               new String[] {"Dial", "Answer", "Playback", "Read", "Hangup", "WaitExten", "Background", "Goto", "GotoIf" }
));

// ^[-_\w]+$
static Pattern endpointDomainPattern = Pattern.compile("^[-_\\w]+$");

Integer parseInteger(String data) {
    Integer val = null;
    try {
        val = Integer.parseInt(data);
    } catch (NumberFormatException nfe) { }
    return val;
}

void validateApplicationPart(String applicationPart, StringBuffer messages, int currentLineIndex)
{
  Matcher matcher = applicationPattern.matcher(applicationPart);
  if (matcher.matches())
  {
    String applicationName = matcher.group(1);
    String applicationArgumentBody = matcher.group(2);
    if ( ! allowedApplicationNames.contains(applicationName))
    {
      messages.append(String.format("%s не является допустимой коммандой, строка %s\n",
                                    applicationName,
                                    currentLineIndex));
    }

    if ("Dial".equals(applicationName))
    {
      validateDialApplication(applicationPart, applicationArgumentBody, messages, currentLineIndex);
    }
    else if (("Hangup".equals(applicationName)) &&
             applicationArgumentBody.length() > 0)
    {
        messages.append(String.format("Hangup application cannot have arguments in '%s' на строке %s\n",
                                      applicationPart,
                                      currentLineIndex));
    }
    else if ("WaitExten".equals(applicationName))
    {
        Integer arg = parseInteger(applicationArgumentBody);
        if (arg == null ||
            arg.intValue() <= 0)
        {
            messages.append(String.format("WaitExten application only have one positive integer argument in '%s' на строке %s\n",
                                          applicationPart,
                                          currentLineIndex));
        }
    }
  }
  else
  {
    messages.append(String.format("Возможна ошибка в комманде '%s' на строке %s\n",
                                  applicationPart,
                                  currentLineIndex));
  }
}

void validateDialApplication(String dialApplication, String applicationArgumentBody, StringBuffer messages, int currentLineIndex)
{
  String[] applicationArguments = applicationArgumentBody.split("\\s*,\\s*", -1);
  if (applicationArguments.length == 2)
  {
    if ( ! StringUtils.isNumeric(applicationArguments[1]))
    {
      messages.append(String.format("'%s' неверный таймаут '%s' на строке %s\n",
                                    applicationArguments[1],
                                    dialApplication,
                                    currentLineIndex));
    }

    String[] firstArgumentParts = applicationArguments[0].split("&", -1);
    for (String endpoint : firstArgumentParts)
    {
      validateDialApplicationEndpoint(endpoint, messages, currentLineIndex);
    }
  }
  else
  {
    messages.append(String.format("Много или не хватает аргументов в '%s' на строке %s\n",
                                  dialApplication,
                                  currentLineIndex));
  }
}

void validateDialApplicationEndpoint(String endpoint, StringBuffer messages, int currentLineIndex)
{
    String endpointExtension = endpoint;
    String[] endpointParts = endpoint.split("@", -1);
    if (endpointParts.length == 2)
    {
        endpointExtension = endpointParts[0];
        String endpointDomain = endpointParts[1];
        Matcher matcher = endpointDomainPattern.matcher(endpointDomain);
        if (! matcher.matches())
        {
            messages.append(String.format("Strange characters in endpoint '%s' after the '@' character на строке %s\n",
                                          endpoint,
                                          currentLineIndex));
        }
    }
    else if (endpointParts.length > 2)
    {
      messages.append(String.format("Too many '@' characters in '%s' на строке %s\n",
                                    endpoint,
                                    currentLineIndex));
    }

    // messages.append(String.format("*** DEBUG endpointExtension is '%s'\n", endpointExtension));

    String endpointExtensionParts[] = endpointExtension.split("/", -1);
    if (endpointExtensionParts.length == 2 &&
        ("SIP".equals(endpointExtensionParts[0]) ||
         "IAX2".equals(endpointExtensionParts[0]) ||
         "Local".equals(endpointExtensionParts[0])))
    {
      if (validExtensions.contains(endpointExtensionParts[1]))
      {
        return;
      }

      String sanitizedEndpoint = endpointExtensionParts[1].replaceAll("\\$\\{DEST[:\\d]*\\}", "")
                                                          .replaceAll("\\$\\{EXTEN[:\\d]*\\}", "");

      // messages.append(String.format("*** DEBUG '%s', sanitized '%s'\n", endpointExtensionParts[1], sanitizedEndpoint));

      if (sanitizedEndpoint.length() == 0 ||
          StringUtils.isNumeric(sanitizedEndpoint))
      {
        return;
      }

      messages.append(String.format("'%s' неправильный или несуществующий добавочный номер на строке %s\n",
                                    endpointExtensionParts[1],
                                    currentLineIndex));
    }
    else
    {
      messages.append(String.format("Формат указан не верно '%s' на строке %s\n",
                                    endpoint,
                                    currentLineIndex));
    }
}


%>

<%
String testresult = "false";
StringBuffer messages = new StringBuffer();
BufferedReader dialplanReader = new BufferedReader(new StringReader(value));

String currentLine;
int currentLineIndex = 0;
while ((currentLine = dialplanReader.readLine()) != null)
{
  ++currentLineIndex;

  if (currentLine.startsWith(";"))
    continue;

  Matcher matcher;

  matcher = extenPattern.matcher(currentLine);
  if (matcher.matches())
  {
    String rulePatternPart = matcher.group(1);
    if (rulePatternPart.length() == 1)
    {
      if ("htins".indexOf(rulePatternPart.charAt(0)) == -1)
      {
        messages.append(String.format("Неверный добавочный номер '%s' в правиле '%s' на строке %s\n",
                                      rulePatternPart.charAt(0),
                                      currentLine,
                                      currentLineIndex));
      }
    }
    else if (rulePatternPart.startsWith("_"))
    {
      // TODO check patterns
    }
    else
    {
      Matcher phoneNumberMatcher = kazakhPhoneNumberPattern.matcher(rulePatternPart);
      if ( ! phoneNumberMatcher.matches())
      {
        messages.append(String.format("Входящий номер '%s' не является Казахстанским на строке %s\n",
                                      rulePatternPart,
                                      currentLineIndex));
      }
    }

    String priorityPart = matcher.group(2);
    if ( ! priorityPart.equals("1"))
    {
      messages.append(String.format("Приоритет '%s' должен быть '1' в правиле '%s' на строке %s\n",
                                    priorityPart,
                                    currentLine,
                                    currentLineIndex));
    }

    String applicationPart = matcher.group(3);
    validateApplicationPart(applicationPart, messages, currentLineIndex);

    continue;
  }

  matcher = samePattern.matcher(currentLine);
  if (matcher.matches())
  {
    String applicationPart = matcher.group(2);
    validateApplicationPart(applicationPart, messages, currentLineIndex);

    continue;
  }

  matcher = commentPattern.matcher(currentLine);
  if (matcher.matches())
  {
    continue;
  }

  matcher = contextPattern.matcher(currentLine);
  if (matcher.matches())
  {
    continue;
  }

  messages.append(String.format("Правило '%s' содержит ошибки, строка %s\n",
                                currentLine,
                                currentLineIndex));
}

if (messages.length() > 0)
{
  jspContext.setAttribute("current", messages);
}

%>

<jsp:doBody/>

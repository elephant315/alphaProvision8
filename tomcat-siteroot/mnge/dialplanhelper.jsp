<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file='app.jsp'%>
<!-- ##########################################################################################-->
<!-- ##########################################################################################-->
<!-- ##########################################################################################-->
<c:if test="${param.template == 'internal'}">
<style>
.ui-autocomplete {
		max-height: 250px;
		overflow-y: auto;
		/* prevent horizontal scrollbar */
		overflow-x: hidden;
		/* add padding to account for vertical scrollbar */
		padding-right: 20px;
	}
	/* IE 6 doesn't support max-height
	 * we use height instead, but this forces the menu to always be this tall
	 */
	* html .ui-autocomplete {
		height: 250px;
	}
.ui-combobox {
	position: relative;
	display: inline-block;
}
.ui-combobox-toggle {
	position: absolute;
	top: 0;
	bottom: 0;
	margin-left: -1px;
	padding: 0;
	/* adjust styles for IE 6/7 */
	*height: 1.7em;
	*top: 0.1em;
}
.ui-combobox-input {
	margin: 0;
	padding: 0.3em;
}
</style>
<script>
(function( $ ) {
	$.widget( "ui.combobox", {
		_create: function() {
			var input,
				self = this,
				select = this.element.hide(),
				selected = select.children( ":selected" ),
				value = selected.val() ? selected.text() : "",
				wrapper = this.wrapper = $( "<span>" )
					.addClass( "ui-combobox" )
					.insertAfter( select );

			input = $( "<input>" )
				.appendTo( wrapper )
				.val( value )
				.addClass( "ui-state-default ui-combobox-input" )
				.autocomplete({
					delay: 0,
					minLength: 0,
					source: function( request, response ) {
						var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
						response( select.children( "option" ).map(function() {
							var text = $( this ).text();
							if ( this.value && ( !request.term || matcher.test(text) ) )
								return {
									label: text.replace(
										new RegExp(
											"(?![^&;]+;)(?!<[^<>]*)(" +
											$.ui.autocomplete.escapeRegex(request.term) +
											")(?![^<>]*>)(?![^&;]+;)", "gi"
										), "<strong>$1</strong>" ),
									value: text,
									option: this
								};
						}) );
					},
					select: function( event, ui ) {
						ui.item.option.selected = true;
						self._trigger( "selected", event, {
							item: ui.item.option
						});
					},
					change: function( event, ui ) {
						if ( !ui.item ) {
							var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( $(this).val() ) + "$", "i" ),
								valid = false;
							select.children( "option" ).each(function() {
								if ( $( this ).text().match( matcher ) ) {
									this.selected = valid = true;
									return false;
								}
							});
							if ( !valid ) {
								// remove invalid value, as it didn't match anything
								$( this ).val( "" );
								select.val( "" );
								input.data( "autocomplete" ).term = "";
								return false;
							}
						}
					}
				})
				.addClass( "ui-widget ui-widget-content ui-corner-left" );

			input.data( "autocomplete" )._renderItem = function( ul, item ) {
				return $( "<li></li>" )
					.data( "item.autocomplete", item )
					.append( "<a>" + item.label + "</a>" )
					.appendTo( ul );
			};

			$( "<a>" )
				.attr( "tabIndex", -1 )
				.attr( "title", "Show All Items" )
				.appendTo( wrapper )
				.button({
					icons: {
						primary: "ui-icon-triangle-1-s"
					},
					text: false
				})
				.removeClass( "ui-corner-all" )
				.addClass( "ui-corner-right ui-combobox-toggle" )
				.click(function() {
					// close if already visible
					if ( input.autocomplete( "widget" ).is( ":visible" ) ) {
						input.autocomplete( "close" );
						return;
					}

					// work around a bug (likely same cause as #5265)
					$( this ).blur();

					// pass empty string as value to search for, displaying all results
					input.autocomplete( "search", "" );
					input.focus();
				});
		},

		destroy: function() {
			this.wrapper.remove();
			this.element.show();
			$.Widget.prototype.destroy.call( this );
		}
	});
})( jQuery );

$(function() {
	$( "#combobox" ).combobox();
	$( "#toggle" ).click(function() {
		$( "#combobox" ).toggle();
	});
});
</script>

<div class="box plain">
	<label><strong>Внутренние звонки</strong><br/></label>	
	<div class="field-group">
		<label for="chkglobal1">набор внутренних линий</label>
		<div class="field">
			<input type="text" name="extpatt" id="extpatt" value="${param.extpatt}${param.extpatt2}" size="32" />
		</div>	
	</div>
	<div class="field-group">
		<label for="chkglobal1">быстрый набор</label>
		<div class="field">
			<input type="text" name="extpatt" id="extpatt2" value="${param.extpatt2}" size="32" />	
		</div>
	</div>
	<div class="field-group">
		<label for="branch">Выберите Город:</label>
		<div class="field">
			<div class="ui-widget">
			<select id="combobox" name="citycode">
				<option value="XXXXXX"></option>
				<option value="72131XXXXX">Абайский р-н (Караганда)</option>
				<option value="72153XXXXX">Абайский р-н (Караганда)</option>
				<option value="72252XXXXX">Абайский р-н (Семипалатинск)</option>
				<option value="71339XXXXX">Айтекебийский р-н (Актобе)</option>
				<option value="71347XXXXX">Айтекебийский р-н (Актобе)</option>
				<option value="71533XXXXX">Айыртауский р-н (Петропавловск)</option>
				<option value="71136XXXXX">Акжаикский р-н (Уральск)</option>
				<option value="71142XXXXX">Акжаикский р-н (Уральск)</option>
				<option value="71146XXXXX">Акжаикский р-н (Уральск)</option>
				<option value="71147XXXXX">Акжаикский р-н (Уральск)</option>
				<option value="71546XXXXX">Акжарский р-н (Петропавловск)</option>
				<option value="71532XXXXX">Аккайынский р-н (Петропавловск)</option>
				<option value="71638XXXXX">Аккольский р-н (Кокшетау)</option>
				<option value="71042XXXXX">Акой (Жезказган)</option>
				<option value="71837XXXXX">Аксуский р-н (Павлодар)</option>
				<option value="72832XXXXX">Аксуский р-н (Талдыкорган)</option>
				<option value="72841XXXXX">Аксуский р-н (Талдыкорган)</option>
				<option value="7292XXXXXX">Актау (Актау)</option>
				<option value="71041XXXXX">Актау (Жезказган)</option>
				<option value="7132XXXXXX">Актобе (Актобе)</option>
				<option value="71037XXXXX">Актогайский р-н (Жезказган)</option>
				<option value="71841XXXXX">Актогайский р-н (Павлодар)</option>
				<option value="71842XXXXX">Актогайский р-н (Павлодар)</option>
				<option value="72757XXXXX">Акший (Алматы)</option>
				<option value="72830XXXXX">Алакольский р-н (Талдыкорган)</option>
				<option value="72833XXXXX">Алакольский р-н (Талдыкорган)</option>
				<option value="72837XXXXX">Алакольский р-н (Талдыкорган)</option>
				<option value="72256XXXXX">Алгабас (Семипалатинск)</option>
				<option value="71337XXXXX">Алгинский р-н (Актобе)</option>
				<option value="727XXXXXXX">Алматы (Алматы)</option>
				<option value="71445XXXXX">Алтынсаринский р-н (Костанай)</option>
				<option value="71438XXXXX">Амангельдинский р-н (Костанай)</option>
				<option value="71440XXXXX">Амангельдинский р-н (Костанай)</option>
				<option value="72433XXXXX">Аральский р-н (Кызылорда)</option>
				<option value="72439XXXXX">Аральский р-н (Кызылорда)</option>
				<option value="71430XXXXX">Аркалык (Костанай)</option>
				<option value="71644XXXXX">Аршалынский р-н (Кокшетау)</option>
				<option value="7172XXXXXX">Астана (Астана)</option>
				<option value="71641XXXXX">АстраXанский р-н (Кокшетау)</option>
				<option value="71643XXXXX">Атбасарский р-н (Кокшетау)</option>
				<option value="7122XXXXXX">Атырау (Атырау)</option>
				<option value="71453XXXXX">Аулиекольский р-н (Костанай)</option>
				<option value="72237XXXXX">Аязог (Семипалатинск)</option>
				<option value="71345XXXXX">Байганинский р-н (Актобе)</option>
				<option value="72637XXXXX">Байзакский р-н (Тараз)</option>
				<option value="72622XXXXX">Байконыр (Байконыр)</option>
				<option value="71036XXXXX">БалXаш (Жезказган)</option>
				<option value="72773XXXXX">БалXашский р-н (Алматы)</option>
				<option value="718405XXXX">Баянаульский р-н (Павлодар)</option>
				<option value="7293232XXX">Бейнеуский р-н (Актау)</option>
				<option value="72236XXXXX">Бескарагайский р-н (Семипалатинск)</option>
				<option value="71140XXXXX">Бокейординский р-н (Уральск)</option>
				<option value="71630XXXXX">Боровое (Кокшетау)</option>
				<option value="72351XXXXX">БородулиXинский р-н (Усть-Каменогорск)</option>
				<option value="72353XXXXX">БородулиXинский р-н (Усть-Каменогорск)</option>
				<option value="71646XXXXX">Буландинский р-н (Кокшетау)</option>
				<option value="71133XXXXX">Бурлинский р-н (Уральск)</option>
				<option value="72138XXXXX">БуXар-Жырауский р-н (Караганда)</option>
				<option value="72154XXXXX">БуXар-Жырауский р-н (Караганда)</option>
				<option value="71535XXXXX">Габита Мусрепова р-н (Петропавловск)</option>
				<option value="72331XXXXX">Глубоковский р-н (Усть-Каменогорск)</option>
				<option value="71434XXXXX">Денисовский р-н (Костанай)</option>
				<option value="71439XXXXX">Джангильдинский р-н (Костанай)</option>
				<option value="71457XXXXX">Джангильдинский р-н (Костанай)</option>
				<option value="71642XXXXX">Егиндыкольский р-н (Кокшетау)</option>
				<option value="72775XXXXX">ЕнбекшиказаXский р-н (Алматы)</option>
				<option value="72776XXXXX">ЕнбекшиказаXский р-н (Алматы)</option>
				<option value="71639XXXXX">Енбекшилдерский р-н (Кокшетау)</option>
				<option value="71633XXXXX">Ерейментауский р-н (Кокшетау)</option>
				<option value="71647XXXXX">Есильский р-н (Кокшетау)</option>
				<option value="71543XXXXX">Есильский р-н (Петропавловск)</option>
				<option value="72836XXXXX">Ескельдинский р-н (Талдыкорган)</option>
				<option value="710403XXXX">Жайрем (ГОК) (Жезказган)</option>
				<option value="71043XXXXX">Жайрем (поселок) (Жезказган)</option>
				<option value="71635XXXXX">Жаксынский р-н (Кокшетау)</option>
				<option value="71649XXXXX">Жаксынский р-н (Кокшетау)</option>
				<option value="72431XXXXX">Жалагашский р-н (Кызылорда)</option>
				<option value="72770XXXXX">Жамбылский р-н (Алматы)</option>
				<option value="71544XXXXX">Жамбылский р-н (Петропавловск)</option>
				<option value="71545XXXXX">Жамбылский р-н (Петропавловск)</option>
				<option value="71547XXXXX">Жамбылский р-н (Петропавловск)</option>
				<option value="72633XXXXX">Жамбылский р-н (Тараз)</option>
				<option value="71030XXXXX">Жана-Аркинский р-н (Жезказган)</option>
				<option value="72435XXXXX">Жанакорганский р-н (Кызылорда)</option>
				<option value="72634XXXXX">Жанатас (Тараз)</option>
				<option value="71141XXXXX">Жангалинский р-н (Уральск)</option>
				<option value="71135XXXXX">Жанибекский р-н (Уральск)</option>
				<option value="71648XXXXX">Жаркаинский р-н (Кокшетау)</option>
				<option value="72345XXXXX">Жарминский р-н (Усть-Каменогорск)</option>
				<option value="72347XXXXX">Жарминский р-н (Усть-Каменогорск)</option>
				<option value="7102XXXXXX">Жезказган (Жезказган)</option>
				<option value="71831XXXXX">Железинский р-н (Павлодар)</option>
				<option value="71435XXXXX">Житикаринский р-н (Костанай)</option>
				<option value="72635XXXXX">Жуалынский р-н (Тараз)</option>
				<option value="71237XXXXX">Жылыойский р-н (Атырау)</option>
				<option value="72340XXXXX">Зайсанский р-н (Усть-Каменогорск)</option>
				<option value="71130XXXXX">Зеленовский р-н (Уральск)</option>
				<option value="71131XXXXX">Зеленовский р-н (Уральск)</option>
				<option value="71149XXXXX">Зеленовский р-н (Уральск)</option>
				<option value="71632XXXXX">Зерендинский р-н (Кокшетау)</option>
				<option value="72335XXXXX">Зыряновск (Усть-Каменогорск)</option>
				<option value="72330XXXXX">Зыряновский р-н (Усть-Каменогорск)</option>
				<option value="72752XXXXX">Илийский р-н (Алматы)</option>
				<option value="71234XXXXX">Индерский р-н (Атырау)</option>
				<option value="713432XXXX">Иргизский р-н (Актобе)</option>
				<option value="71832XXXXX">Иртышский р-н (Павлодар)</option>
				<option value="718442XXXX">Иртышский р-н (Павлодар)</option>
				<option value="71231XXXXX">Исатайский р-н (Атырау)</option>
				<option value="72438XXXXX">Казалинский р-н (Кызылорда)</option>
				<option value="71138XXXXX">Казталовский р-н (Уральск)</option>
				<option value="71144XXXXX">Казталовский р-н (Уральск)</option>
				<option value="71437XXXXX">Камыстинский р-н (Костанай)</option>
				<option value="72772XXXXX">Капчагай (Алматы)</option>
				<option value="71441XXXXX">Карабалыкский р-н (Костанай)</option>
				<option value="71447XXXXX">Карабалыкский р-н (Костанай)</option>
				<option value="7212XXXXXX">Караганда (Караганда)</option>
				<option value="71032XXXXX">Каражал (Жезказган)</option>
				<option value="72935XXXXX">Каракиянский р-н (Актау)</option>
				<option value="7293741XXX">Каракиянский р-н (Актау)</option>
				<option value="72740XXXXX">Карасайский р-н (Алматы)</option>
				<option value="72771XXXXX">Карасайский р-н (Алматы)</option>
				<option value="71448XXXXX">Карасуский р-н (Костанай)</option>
				<option value="71452XXXXX">Карасуский р-н (Костанай)</option>
				<option value="72834XXXXX">Каратальский р-н (Талдыкорган)</option>
				<option value="71145XXXXX">Каратобинский р-н (Уральск)</option>
				<option value="71342XXXXX">Каргалинский р-н (Актобе)</option>
				<option value="72147XXXXX">Каркаралинский р-н (Караганда)</option>
				<option value="72437XXXXX">Кармакшинский р-н (Кызылорда)</option>
				<option value="72341XXXXX">Катон-Карагайский р-н (Усть-Каменогорск)</option>
				<option value="72342XXXXX">Катон-Карагайский р-н (Усть-Каменогорск)</option>
				<option value="71456XXXXX">Качар (Костанай)</option>
				<option value="71833XXXXX">Качирский р-н (Павлодар)</option>
				<option value="72840XXXXX">Кербулакский р-н (Талдыкорган)</option>
				<option value="72842XXXXX">Кербулакский р-н (Талдыкорган)</option>
				<option value="71238XXXXX">Кзылкогинский р-н (Атырау)</option>
				<option value="72333XXXXX">Кокпектинский р-н (Усть-Каменогорск)</option>
				<option value="72348XXXXX">Кокпектинский р-н (Усть-Каменогорск)</option>
				<option value="72838XXXXX">Коксуский р-н (Талдыкорган)</option>
				<option value="7162XXXXXX">Кокшетау (Кокшетау)</option>
				<option value="71637XXXXX">Коргалжынский р-н (Кокшетау)</option>
				<option value="7142XXXXXX">Костанай (Костанай)</option>
				<option value="71455XXXXX">Костанайский р-н (Костанай)</option>
				<option value="7145834XXX">Красногорск (Костанай)</option>
				<option value="71233XXXXX">Курмангазинский р-н (Атырау)</option>
				<option value="72251XXXXX">Курчатов (Семипалатинск)</option>
				<option value="72339XXXXX">Курчумский р-н (Усть-Каменогорск)</option>
				<option value="72343XXXXX">Курчумский р-н (Усть-Каменогорск)</option>
				<option value="71538XXXXX">Кызылжарский р-н (Петропавловск)</option>
				<option value="71539XXXXX">Кызылжарский р-н (Петропавловск)</option>
				<option value="7242XXXXXX">Кызылорда (Кызылорда)</option>
				<option value="71839XXXXX">Лебяжинский р-н (Павлодар)</option>
				<option value="72843XXXXX">Лепсы (Талдыкорган)</option>
				<option value="71433XXXXX">Лисаковск (Костанай)</option>
				<option value="71531XXXXX">Магжана Жумабаева р-н (Петропавловск)</option>
				<option value="71843XXXXX">Майский р-н (Павлодар)</option>
				<option value="71838XXXXX">Майский р-он (Павлодар)</option>
				<option value="71235XXXXX">Макатский р-н (Атырау)</option>
				<option value="71239XXXXX">Макатский р-н (Атырау)</option>
				<option value="71541XXXXX">Мамлютский р-н (Петропавловск)</option>
				<option value="72934XXXXX">Мангистауская обл (Актау)</option>
				<option value="72931XXXXX">Мангистауский р-н (Актау)</option>
				<option value="71331XXXXX">Мартукский р-н (Актобе)</option>
				<option value="71236XXXXX">МаXамбетский р-н (Атырау)</option>
				<option value="71443XXXXX">Мендыкаринский р-н (Костанай)</option>
				<option value="72632XXXXX">Меркенский р-н (Тараз)</option>
				<option value="72640XXXXX">Мойынкумский р-н (Тараз)</option>
				<option value="72642XXXXX">Мойынкумский р-н (Тараз)</option>
				<option value="71333XXXXX">Мугалжарский р-н (Актобе)</option>
				<option value="71334XXXXX">Мугалжарский р-н (Актобе)</option>
				<option value="71454XXXXX">Наурзумский р-н (Костанай)</option>
				<option value="72132XXXXX">Нуринский р-н (Караганда)</option>
				<option value="72144XXXXX">Нуринский р-н (Караганда)</option>
				<option value="72148XXXXX">Осакаровский р-н (Караганда)</option>
				<option value="72149XXXXX">Осакаровский р-н (Караганда)</option>
				<option value="7182XXXXXX">Павлодар (Павлодар)</option>
				<option value="72831XXXXX">Панфиловский р-н (Талдыкорган)</option>
				<option value="7152XXXXXX">Петропавловск (Петропавловск)</option>
				<option value="71039XXXXX">Приозерск (Жезказган)</option>
				<option value="72631XXXXX">р-н Турара Рыскулова (Тараз)</option>
				<option value="72777XXXXX">Райымбекский р-н (Алматы)</option>
				<option value="72779XXXXX">Райымбекский р-н (Алматы)</option>
				<option value="72336XXXXX">Риддер (Усть-Каменогорск)</option>
				<option value="71431XXXXX">Рудный (Костанай)</option>
				<option value="71640XXXXX">Сандыктауский р-н (Кокшетау)</option>
				<option value="72137XXXXX">Сарань (Караганда)</option>
				<option value="72839XXXXX">Саркандский р-н (Талдыкорган)</option>
				<option value="71451XXXXX">Сарыкольский р-н (Костанай)</option>
				<option value="72639XXXXX">Сарысуский р-н (Тараз)</option>
				<option value="71063XXXXX">Сатпаев (Жезказган)</option>
				<option value="7222XXXXXX">Семипалатинск (Семипалатинск)</option>
				<option value="72337XXXXX">Серебрянск (Усть-Каменогорск)</option>
				<option value="727581XXXX">СП Сател (Алматы)</option>
				<option value="71645XXXXX">Степногорск (Кокшетау)</option>
				<option value="72436XXXXX">Сырдарьинский р-н (Кызылорда)</option>
				<option value="71038XXXXX">Сыры-Шаган (Жезказган)</option>
				<option value="71134XXXXX">Сырымский р-н (Уральск)</option>
				<option value="71536XXXXX">Тайыншинский р-н (Петропавловск)</option>
				<option value="72641XXXXX">Таласский р-н (Тараз)</option>
				<option value="72644XXXXX">Таласский р-н (Тараз)</option>
				<option value="72774XXXXX">Талгарский р-н (Алматы)</option>
				<option value="7282XXXXXX">Талдыкорган (Талдыкорган)</option>
				<option value="7262XXXXXX">Тараз (Тараз)</option>
				<option value="71436XXXXX">Тарановский р-н (Костанай)</option>
				<option value="71449XXXXX">Тарановский р-н (Костанай)</option>
				<option value="72344XXXXX">Тарбагатайский р-н (Усть-Каменогорск)</option>
				<option value="72346XXXXX">Тарбагатайский р-н (Усть-Каменогорск)</option>
				<option value="71139XXXXX">Таскалинский р-н (Уральск)</option>
				<option value="72835XXXXX">Текели (Талдыкорган)</option>
				<option value="71346XXXXX">Темирский р-н (Актобе)</option>
				<option value="7213XXXXXX">Темиртау (Караганда)</option>
				<option value="712302XXXX">Тенгизшевройл (Атырау)</option>
				<option value="712303XXXX">Тензиз (Атырау)</option>
				<option value="71132XXXXX">Теректинский р-н (Уральск)</option>
				<option value="71143XXXXX">Теректинский р-н (Уральск)</option>
				<option value="71537XXXXX">Тимирязевский р-н (Петропавловск)</option>
				<option value="72938XXXXX">Тупкараганский р-н (Актау)</option>
				<option value="71540XXXXX">УалиXановский р-н (Петропавловск)</option>
				<option value="71542XXXXX">УалиXановский р-н (Петропавловск)</option>
				<option value="71444XXXXX">Узункольский р-н (Костанай)</option>
				<option value="714463XXXX">Узункольский р-н (Костанай)</option>
				<option value="713322XXXX">Уилский р-н (Актобе)</option>
				<option value="72778XXXXX">Уйгурский р-н (Алматы)</option>
				<option value="72334XXXXX">Уланский р-н (Усть-Каменогорск)</option>
				<option value="72338XXXXX">Уланский р-н (Усть-Каменогорск)</option>
				<option value="71034XXXXX">Улытауский р-н (Жезказган)</option>
				<option value="71035XXXXX">Улытауский р-н (Жезказган)</option>
				<option value="7112XXXXXX">Уральск (Уральск)</option>
				<option value="72230XXXXX">Урджарский р-н (Семипалатинск)</option>
				<option value="72239XXXXX">Урджарский р-н (Семипалатинск)</option>
				<option value="71834XXXXX">Успенский р-н (Павлодар)</option>
				<option value="7232XXXXXX">Усть-Каменогорск (Усть-Каменогорск)</option>
				<option value="71442XXXXX">Федоровский р-н (Костанай)</option>
				<option value="71340XXXXX">Xобдинский р-н (Актобе)</option>
				<option value="71341XXXXX">Xобдинский р-н (Актобе)</option>
				<option value="7133022XXX">Xромтауский р-н (Актобе)</option>
				<option value="71336XXXXX">Xромтауский р-н (Актобе)</option>
				<option value="71651XXXXX">Целиноградский р-н (Кокшетау)</option>
				<option value="71137XXXXX">Чингирлауский р-н (Уральск)</option>
				<option value="71534XXXXX">Шал Акына р-н (Петропавловск)</option>
				<option value="71335XXXXX">Шалкарский р-н (Актобе)</option>
				<option value="71348XXXXX">Шалкарский р-н (Актобе)</option>
				<option value="71349XXXXX">Шалкарский р-н (Актобе)</option>
				<option value="72156XXXXX">ШаXтинск (Караганда)</option>
				<option value="72332XXXXX">ШемонаиXинский р-н (Усть-Каменогорск)</option>
				<option value="71031XXXXX">Шетский р-н (Жезказган)</option>
				<option value="71033XXXXX">Шетский р-н (Жезказган)</option>
				<option value="72432XXXXX">Шиелийский р-н (Кызылорда)</option>
				<option value="71631XXXXX">Шортандинский р-н (Кокшетау)</option>
				<option value="72257XXXXX">Шульбинск (Семипалатинск)</option>
				<option value="72638XXXXX">Шуский р-н (Тараз)</option>
				<option value="72643XXXXX">Шуский р-н (Тараз)</option>
				<option value="71836XXXXX">Щербактинский р-н (Павлодар)</option>
				<option value="71636XXXXX">Щучинский р-н (Кокшетау)</option>
				<option value="71835XXXXX">Экибастуз (Павлодар)</option>
				<option value="72246XXXXX">Эмельтау (Семипалатинск)</option>
			</select>
			</div>
		</div>
	</div>
	<hr/>
	<div class="actions">						
		<button type="submit" class="btn btn-success" id="subm">Применить</button><br/>
	</div> <!-- .actions -->
</div> <!-- .widget-content -->



<script>
$( "#subm" ).click(function() {
var valcity = $("#combobox").val();
var citypatt = valcity.substr(valcity.indexOf("X"),valcity.length-valcity.indexOf("X"));
var citycode = valcity.substr(0,valcity.indexOf("X"));
editor.setValue("[default_local]\n\
;Local\n\
exten => _"+$( "#extpatt" ).val()+",1,Dial(SIP/\${EXTEN},60)\n\
exten => _"+$( "#extpatt2" ).val()+",1,Dial(SIP/${param.extpatt}\${EXTEN},60)\n\
;City\n\
exten => _"+citypatt+",1,Dial(SIP/\${EXTEN}@ktel-default,60)\n\
exten => _9"+citypatt+",1,Dial(SIP/\${EXTEN:1}@ktel-default,60)\n\
exten => _"+citycode+citypatt+",1,Dial(SIP/\${EXTEN:"+citycode.length+"}@ktel-default,60)\n\
exten => _8"+citycode+citypatt+",1,Dial(SIP/\${EXTEN:"+(citycode.length+1)+"}@ktel-default,60)");
	editor.setOption("readOnly",false );
	editor.focus();
	$('#starteditbtn').hide();
	$.modal.close();
});
</script>
</c:if>

<!-- ##########################################################################################-->
<!-- ##########################################################################################-->
<!-- ##########################################################################################-->
<c:if test="${param.template == 'external'}">
<div class="box plain">
	<label><strong>Внешние звонки звонки</strong><br/></label>	
	<div class="field-group">
		<label for="chkglobal1">Внешняя линия для корпоративного дозвона</label>
		<div class="field">
			<input type="text" name="corpline" id="corpline" value="${param.extcitycode}" size="32" />
		</div>
	</div>
	<hr/>
	<div class="actions">
		<button type="submit" class="btn btn-success" id="subm">Применить</button><br/>
	</div> <!-- .actions -->
</div> <!-- .widget-content -->

<script>
$( "#subm" ).click(function() {
editor.setValue("[from-trunk]\n\
;CorporateTrunk\n\
exten => "+$( "#corpline" ).val()+",1,Answer()\n\
same => n,Read(DEST,,7,sn,0,3)\n\
same => n,Dial(SIP/\${DEST},60)\n\
;LocalTrunk\n\
exten => "+$( "#corpline" ).val()+",1,Dial(SIP/11300,60)\n\
exten => h,1,Hangup()\n\
exten => t,1,Hangup()\n\
exten => i,1,Hangup()");
	editor.setOption("readOnly",false );
	editor.focus();
	$('#starteditbtn').hide();
	$.modal.close();
});
</script>
</c:if>

<!-- ##########################################################################################-->
<!-- ##########################################################################################-->
<!-- ##########################################################################################-->
<c:if test="${param.template == 'trunk'}">
<div class="box plain">
	<div class="field-group control-group inline">	
		<label><strong>Выберите тарифный план:</strong><br/></label>	
		<div class="field">
			<input type="radio" name="radio1" class="radio1" value="1" checked/>
			<label for="chkglobal1">Транк IDphone</label>
		</div>
		<div class="field">
			<input type="radio" name="radio1" class="radio1" value="2" />
			<label for="chkglobal2">Казаxтелеком Business trunk</label>
		</div>
	</div>
	<hr/>
	<div class="actions">						
		<button type="submit" class="btn btn-success" id="subm">Применить</button><br/>
	</div> <!-- .actions -->
</div> <!-- .widget-content -->

<script>
$( "#subm" ).click(function() {
if ($('.radio1:checked').val() == '1') {
editor.setValue("register=LOGIN@sip.telecom.kz:PASSWORD@172.210.0.1/${param.extcitycode}PHONENUM\n\
register=LOGIN@sip.telecom.kz:PASSWORD@172.210.0.1/${param.extcitycode}PHONENUM\n\
\n\
[idphone](!)\n\
type=peer\n\
qualify=no\n\
host=172.210.0.1\n\
fromdomain=sip.telecom.kz\n\
dtmfmode=rfc2833\n\
disallow=all\n\
allow=alaw\n\
insecure=invite\n\
context=from-trunk\n\
\n\
[ktel-default](idphone)\n\
fromuser = LOGIN\n\
username = LOGIN\n\
secret = PASSWORD\n\
\n\
[ktel-1](idphone)\n\
fromuser = LOGIN\n\
username = LOGIN\n\
secret = PASSWORD\n\
");
}
if ($('.radio1:checked').val() == '2') {
editor.setValue("[ktel-default]\n\
type=peer\n\
qualify=no\n\
host=SIPSERVERIP\n\
fromdomain=PBXIP\n\
fromuser=${param.extcitycode}PHONENUM\n\
dtmfmode=rfc2833\n\
disallow=all\n\
allow=alaw\n\
insecure=invite\n\
context=from-trunk");}
	editor.setOption("readOnly",false );
	editor.focus();
	$('#starteditbtn').hide();
	$.modal.close();
});
</script>
</c:if>

<!-- ##########################################################################################-->
<!-- ##########################################################################################-->
<!-- ##########################################################################################-->
<c:if test="${param.template == 'ivr'}">
<div class="box plain">
	<hr/>
	<div class="actions">						
		<button type="submit" class="btn btn-success" id="subm">Применить</button><br/>
	</div> <!-- .actions -->
</div> <!-- .widget-content -->

<script>
$( "#subm" ).click(function() {
editor.setValue(";def ivr");
	editor.setOption("readOnly",false );
	editor.focus();
	$('#starteditbtn').hide();
	$.modal.close();
});
</script>
</c:if>
<!-- ##########################################################################################-->
<!-- ##########################################################################################-->
<!-- ##########################################################################################-->
<c:if test="${param.template == 'global'}">

	<sql:query dataSource="${databas}" var="getBr">
		select id,dialplan2,dialplan1,city from branchesorg_${G_org}_${G_ver} where dialplan2 is not null and dialplan1 is not null order by city
	</sql:query>
	<c:forEach var="dbo" items="${getBr.rows}">
		<sql:query dataSource="${databas}" var="getExt">
		select id,extension,name,secondname from extensionsorg_${G_org}_${G_ver} where branchid=?
		<sql:param value="${dbo.id}"/>
		</sql:query>
		<c:if test="${(getExt.rowCount > 0) and (fn:length(getExt.rows[0].extension) > 3)}">
			<c:set var="nopattern" value="0"/>
			<c:set var="ei" value="3"/>
				<c:if test="${fn:startsWith(getExt.rows[0].extension,'1')}"><c:set var="ei" value="2"/></c:if>
			<c:set var="pref">${fn:substring(getExt.rows[0].extension,0,ei)}</c:set>
			<c:forEach items="${getExt.rows}" var="che">
				<c:if test="${fn:substring(che.extension,0,ei) != pref}">
					<c:set var="nopattern" value="1"/>
				</c:if>
			</c:forEach>
				<c:if test="${nopattern == '1'}">
					<c:set var="nopattern" value="0"/>
					<c:set var="ei" value="2"/>
					<c:set var="pref">${fn:substring(getExt.rows[0].extension,0,ei)}</c:set>
					<c:forEach items="${getExt.rows}" var="che">
						<c:if test="${fn:substring(che.extension,0,ei) != pref}">
							<c:set var="nopattern" value="1"/>
						</c:if>
					</c:forEach>
				</c:if>
				<c:if test="${nopattern == '1'}">
					<c:set var="nopattern" value="0"/>
					<c:set var="ei" value="1"/>
					<c:set var="pref">${fn:substring(getExt.rows[0].extension,0,ei)}</c:set>
					<c:forEach items="${getExt.rows}" var="che">
						<c:if test="${fn:substring(che.extension,0,ei) != pref}">
							<c:set var="nopattern" value="1"/>
						</c:if>
					</c:forEach>
				</c:if>
			<c:if test="${nopattern == '0'}"> 
				<c:set var="extpatt">${pref}</c:set>
				<c:set var="extpatt2"><c:forEach begin='1' end='${fn:length(getExt.rows[0].extension)-fn:length(pref)}'>X</c:forEach></c:set>
			</c:if>
		</c:if>	
		<c:set var="extpatt3">${extpatt}${extpatt2}</c:set>
		<c:if test="${fn:length(extpatt3) == 5}">
			<c:set var="landcorp">${fn:substringAfter(dbo.dialplan2, ";CorporateTrunk")}</c:set>
			<c:set var="landcorp">${fn:substringAfter(landcorp, "exten => ")}</c:set>
			<c:set var="landcorp">${fn:substringBefore(landcorp, ",1,Answer()")}</c:set>
				<c:if test="${fn:length(landcorp) > 3}">
						<c:if test="${dbo.city != tcity}"><c:set var="globplan1" value="${globplan1};${dbo.city}\\n\\${newline}"/></c:if>
						<c:remove var="repeaterror"/><c:set var="chkexpatt3">_${extpatt3},1,Dial</c:set><c:if test='${fn:contains(globplan1,chkexpatt3) == true}'><c:set var="repeaterror">;dublicate:</c:set></c:if>
						<c:set var="globplan1" value="${globplan1}${repeaterror}exten => _${extpatt3},1,Dial(SIP/${landcorp}@ktel-default,,rM(sendnum,${dbo.id}\${EXTEN})) ;id:${dbo.id} \\n\\${newline}"/>
							<c:set var="citycodec">${fn:substringAfter(dbo.dialplan1, "City")}</c:set>
							<c:set var="citycodec">${fn:substringAfter(citycodec, "_8")}</c:set>
							<c:set var="citycodec">${fn:substringBefore(citycodec, ",1,Dial")}</c:set>
							<c:choose>
							<c:when test="${fn:length(citycodec) == 10}">
								<c:set var="globplan1" value="${globplan1}${repeaterror}exten => _8${citycodec},1,Dial(SIP/${landcorp}@ktel-default,,rM(sendnum,${dbo.id}\${EXTEN})) ;id:${dbo.id} \\n\\${newline}"/>
							</c:when>
							<c:otherwise>
								<c:set var="globplan1" value="${globplan1};failed to generate inter-city rule for id:${dbo.id} \\n\\${newline}"/>
							</c:otherwise>
							</c:choose>
						<c:set var="tcount" value="${tcount+1}"/>
						<c:set var="tcity" value="${dbo.city}"/>
				</c:if>
		</c:if>
	</c:forEach>

<div class="box plain">
	<div class="actions">Будут созданы правила для ${tcount} офисов <hr/>
		<button type="submit" class="btn btn-success" id="subm">Применить</button><br/>
	</div> <!-- .actions -->
</div> <!-- .widget-content -->

<script>
$( "#subm" ).click(function() {
editor.setValue("${globplan1}\n\
;default\n\
exten => h,1,Hangup()\n\
exten => t,1,Hangup()\n\
exten => i,1,Hangup()\n\
;some basic functions\n\
[macro-sendnum]\n\
exten => s,1,Wait(1)\n\
same => n,SendDTMF(\${ARG1})");
	editor.setOption("readOnly",false );
	editor.focus();
	$('#starteditbtn').hide();
	$.modal.close();
});
</script>
</c:if>
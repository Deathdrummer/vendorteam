/*
	Создается три шаблона: список (list.tpl), новая запись (new.tpl), и подстановочная запись после сохранения (saved.tpl)
	- в списке update и remove
	- в новой save
	- в подстановочной update remove

	В контроллере создается одна функция со свитчем: get add save update remove
	- get (список записей с тегами update и remove)
	- add (новая запись с тегом save)
	- save (передача полей (POST "fields" и "fields_to_item") с последующим выводом шаблона saved.tpl с тегами update и remove)
	- update (передача полей с последующим выводом статуса обновления)
	- remove (передача ID записи с последующим выводом статуса удаления)
*/
$.fn.ddrCRUD = function(settings, callback) {
	if (this.length == 0) {
		console.warn('ddrCRUD ошибка! Селектор: не найден!');
		return false;
	} 
	
	var selector = this,
		thisItemSelector,
		thisItemTag,
		thisItemClass,
		obj = {},
		ops = $.extend({
			addSelector: false, // селектор для добавления новой записи
			getListParams: {}, // параметры для получения списка данных
			emptyList: '<p class="empty">Нет данных</p>', // Текст при пустом листе
			functions: false, // PHP функции, например: account/personages/[get,add,save,update,remove]
			confirms: {
				add: false, // функция при добавлении записи
				save: false, // функция при сохранении записи
				update: false, // функция при обновлении записи
				remove: false, // функция при удалении записи
			},
			removeConfirm: false, // Запрашивать подтверждение перед удалением
			listDirection: 'bottom', // направление списка: top bottom (добавление новой записи внизу или вверху)
			popup: false // Если список в попап окне - указать объект окна
		}, settings),
		functions = ops.functions.substr(-1) != '/' ? ops.functions+'/' : ops.functions,
		functions = functions.substr(0, 1) != '/' ? '/'+functions : functions;
	
	
	getAjaxHtml(functions+'get', ops.getListParams, function(html, getListStat) {
		if (!getListStat) $(selector).html(ops.emptyList);
		else $(selector).html(html);
		$(selector).find('[update]').setAttrib('disabled');
		
		if (getListStat) {
			thisItemSelector = $(selector).children()[0],
			thisItemTag = thisItemSelector.localName,
			thisItemClass = ''; //thisItemSelector.className ? '.'+thisItemSelector.className : '';
		}
		
		
		$(selector).changeRowInputs(function(row, item) {
			$(item).closest(thisItemTag+thisItemClass).find('[update]:disabled, [save]:disabled').removeAttrib('disabled');
		});
		
		
		// Добавить запись
		$(ops.addSelector).on(tapEvent, function() {
			getAjaxHtml(functions+'add', function(html) {
				if (!getListStat) {
					$(selector).children().first().remove();
					thisItemSelector = $(html)[0],
					thisItemTag = thisItemSelector.localName,
					thisItemClass = ''; //thisItemSelector.className ? '.'+thisItemSelector.className : '';
					$(selector).html(html);
					getListStat = true;
					$(selector).find('[save]').setAttrib('disabled');
					if (typeof ops.confirms.add == 'function') ops.confirms.add($(selector).children().first());
				} else {
					if (ops.listDirection == 'bottom') {
						$(selector).append(html);
						$(selector).find('[save]').setAttrib('disabled');
						if (typeof ops.confirms.add == 'function') ops.confirms.add($(selector).children().last());
					} else if (ops.listDirection == 'top') {
						$(selector).prepend(html);
						$(selector).find('[save]').setAttrib('disabled');
						if (typeof ops.confirms.add == 'function') ops.confirms.add($(selector).children().first());
					} 
				}
			});
		});
		
		
		
		// Сохранить запись
		$(selector).on(tapEvent, '[save]', function() {
			var thisItem = this,
				thisItemSelector = $(thisItem).closest(thisItemTag+thisItemClass),
				//sf = ops.saveListItem.substr(0, 1) != '/' ? '/'+ops.saveListItem : ops.saveListItem,
				fields = {},
				fieldsToItem = {};
			
			$(thisItemSelector).find('input, textarea, select').each(function(e) {
				var name = $(this).attr('name'),
					val = this.type == 'checkbox' ? ($(this).is(':checked') ? 1 : 0) : $(this).val(),
					text = this.type == 'select-one' ? $(this).children('option:selected').text() : (this.type == 'checkbox' ? ($(this).is(':checked') ? 1 : 0) : $(this).val());
				fields[name] = val;
				fieldsToItem[name] = text;
			});
			
			getAjaxHtml(functions+'save', {fields: fields, fields_to_item: fieldsToItem}, function(html, saveStat) {
				if (saveStat) {
					$(thisItemSelector).replaceWith(function() {
						return html.replace(/(update="\d+")/, '$1 disabled');
					});
					notify('Запись успешно сохранена!');
					if (typeof ops.confirms.save == 'function') ops.confirms.save(thisItemSelector);
				} else {
					notify('Не удалось сохранить запись!', 'error');
				}
			});
		});
		
		
		
		// Обновить запись
		$(selector).on(tapEvent, '[update]', function() {
			var thisItem = this,
				thisId = $(thisItem).attr('update'),
				thisItemSelector = $(this).closest(thisItemTag+thisItemClass),
				fields = {};
			
			$(thisItemSelector).find('input, textarea, select').each(function(e) {
				var name = $(this).attr('name'),
					val = this.type == 'checkbox' ? ($(this).is(':checked') ? 1 : 0) : $(this).val();
				fields[name] = val;
			});
			
			$.post(functions+'update', {id: thisId, fields: fields}, function(response) {
				if (response) {
					notify('Запись успешно обновлена!');
					$(thisItem).setAttrib('disabled');
					$(thisItemSelector).removeClass('changed');
					if (typeof ops.confirms.update == 'function') ops.confirms.update(thisItemSelector);
				} else {
					notify('Не удалось сохранить запись!', 'error');
				}
			}, 'json').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		});
		
		
		
		// Удалить запись
		$(selector).on(tapEvent, '[remove]', function() {
			var thisId = $(this).attr('remove'),
				thisItem = $(this).closest(thisItemTag+thisItemClass);
			
			// Удалить несохраненную запись
			if (!thisId) {
				$(thisItem).remove();
				notify('Запись удалена!');
				if ($(selector).find(thisItemTag+thisItemClass).length == 0) {
					$(selector).html(ops.emptyList);
					getListStat = false;
				}
				return true;
			}
			
			function removeRow() {
				$.post(functions+'remove', {id: thisId}, function(response) {
					if (response) {
						if (typeof ops.confirms.remove == 'function') ops.confirms.remove(thisItem);
						$(thisItem).remove();
						notify('Запись удалена!');
						if ($(selector).find(thisItemTag+thisItemClass).length == 0) {
							$(selector).html(ops.emptyList);
							getListStat = false;
						}
					} else {
						notify('Ошибка удаления!', 'error');
					}
				}, 'json').fail(function(e) {
					notify('Системная ошибка!', 'error');
					showError(e);
				});
			}
			
			if (ops.removeConfirm) {
				if (ops.popup) {
					ops.popup.dialog('<p>Вы действительно хотите удалить запись?</p>', 'Удалить', 'Отмена', function() {
						ops.popup.wait();
						removeRow();
						ops.popup.wait(false);
						ops.popup.dialog(false);
					});
				} else {
					popUp({
						title: 'Удалить запись',
					    width: 400,
					    html: '<p class="center" style="color: #c54747;">Вы действительно хотите удалить запись?</p>',
					    buttons: [{id: 'removeConfY', title: 'Да'}],
					    closeButton: 'Нет',
					}, function(removeConfYWin) {
						$('#removeConfY').on(tapEvent, function() {
							removeConfYWin.wait();
							removeRow();
							removeConfYWin.close();
						});
					});
				}
			} else {
				removeRow();
			}
			
		});
		
		
		
		
		
		
		
		//---------------------------------- Методы
		// Сбросить фильтр и поиск 
		obj.reset = function() {
			getAjaxHtml(functions+'get', function(html, getListStat) {
				if (!getListStat) $(selector).html(ops.emptyList);
				else $(selector).html(html);
				$(selector).find('[update]').setAttrib('disabled');
			});
		};
		
		
		// before after none both
		obj.search = function(field, search, place) {
			getAjaxHtml(functions+'get', {field: field, search: search, place: place}, function(html, getListStat) {
				if (!getListStat) $(selector).html(ops.emptyList);
				else $(selector).html(html);
				$(selector).find('[update]').setAttrib('disabled');
			});
		};
		
		
		// where: метод (where) => [условие => значение]
		obj.where = function(where) {
			getAjaxHtml(functions+'get', {where: where}, function(html, getListStat) {
				if (!getListStat) $(selector).html(ops.emptyList);
				else $(selector).html(html);
				$(selector).find('[update]').setAttrib('disabled');
			});
		};
			
		
		
		
		
	}, function() {
		if (typeof callback == 'function') {
			callback(obj);
		}
	});
};
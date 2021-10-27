/*
	Создается три шаблона: список (list.tpl), новая запись (new.tpl), и подстановочная запись после сохранения (saved.tpl или item.tpl)
	- в списке update и remove
	- в новой save
	- в подстановочной update remove

	В контроллере создается одна функция со свитчем: get add save update remove
	- get (список записей с тегами update и remove)
	- add (новая запись с тегом save)
	- save (передача полей (POST "fields" и "fields_to_item") с последующим выводом шаблона saved.tpl с тегами update и remove)
	- update (передача полей с последующим выводом статуса обновления)
	- remove (передача ID записи с последующим выводом статуса удаления)

	- Параметры
		- addSelector: false, // селектор для добавления новой записи
		- autoAdd: false // автодобавление одной записи
		- sortField: // поле сортировки в таблице
		- emptyList: '<p class="empty">Нет данных</p>', // Текст при пустом листе
		- functions: false, // PHP функции, например: account/personages/[get,add,save,update,remove]
		- data: {
			- getList: {}, //Данные при получении списка записей
			- add: {}, // Данные при добавлении записи
			- save: {}, // Данные при сохранении записи
			- update: {}, // Данные при обновлении записи
			- remove: {} // Данные при удалении записи
		},
		- before: {
				- getList: false, // функция перед формированием списка записей
				- add: false, // функция перед добавлением записи
				- save: false, // функция перед сохранением записи
				- update: false, // функция перед обновлением записи
				- remove: false // функция перед удалением записи
			},
		- confirms: {
			- getList: false, // функция при формировании списка записей
			- add: false, // функция при добавлении записи
			- save: false, // функция при сохранении записи
			- update: false, // функция при обновлении записи
			- remove: false, // функция при удалении записи
		},
		- removeConfirm: false, // Запрашивать подтверждение перед удалением bool или строка диалога
		- listDirection: 'bottom', // направление списка: top bottom (добавление новой записи внизу или вверху)
		- popup: false // Если список в попап окне - указать объект окна
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
			autoAdd: false,
			sortField: '_sort', // поле сортировки в таблице
			emptyList: '<p class="empty">Нет данных</p>', // Текст при пустом листе
			errorFields: false, // возвращает данные при ошибке формы
			functions: false, // PHP функции, например: account/personages/[get,add,save,update,remove]
			data: {
				getList: {}, //Данные при получении списка записей
				add: {}, // Данные при добавлении записи
				save: {}, // Данные при сохранении записи
				update: {}, // Данные при обновлении записи
				remove: {} // Данные при удалении записи
			},
			before: {
				getList: false, // функция перед формированием списка записей
				add: false, // функция перед добавлением записи
				save: false, // функция перед сохранением записи
				update: false, // функция перед обновлением записи
				remove: false // функция перед удалением записи
			},
			confirms: {
				getList: false, // функция при формировании списка записей
				add: false, // функция при добавлении записи
				save: false, // функция при сохранении записи
				update: false, // функция при обновлении записи
				remove: false // функция при удалении записи
			},
			removeConfirm: false, // Запрашивать подтверждение перед удалением
			listDirection: 'bottom', // направление списка: top bottom (добавление новой записи внизу или вверху)
			exceptions: false, // селекторы-исключения при клике на которые не будут страбатывать кнопки "сохранить" и "удалить" запись ['[attrib1]', '#id2', ...]
			popup: false // Если список в попап окне - указать объект окна
		}, settings),
		initParams = ops.data.getList,
		functions = ops.functions.substr(-1) != '/' ? ops.functions+'/' : ops.functions,
		functions = functions.substr(0, 1) != '/' ? '/'+functions : functions,
		countCols = $(ops.emptyList).find('td').attr('colspan') || false,
		waitHtml = '';


	if (countCols) {
		waitHtml += '<tr>';
		waitHtml += 	'<td colspan="'+countCols+'" class="center">';
		waitHtml += 		'<i class="fa fa-spinner fa-pulse fa-2x fa-fw"></i>';
		waitHtml += 	'</td>';
		waitHtml += '</tr>';
	}

	$(selector).html(waitHtml);

	// функция при получении списка
	function _getListActions() {
		if (typeof setBaseScripts == 'function') setBaseScripts();
		if (typeof ops.confirms.getList == 'function') ops.confirms.getList();
	};


	getAjaxHtml(functions+'get', ops.data.getList, function(html, getListStat) {
		if (typeof ops.before.getList == 'function') ops.before.getList();
		if (!getListStat) $(selector).html(ops.emptyList);
		else $(selector).html(html);

		$(selector).find('[update]').setAttrib('disabled');

		if (getListStat) {
			thisItemSelector = $(selector).children()[0],
			thisItemTag = thisItemSelector.localName,
			thisItemClass = thisItemSelector.className ? '.'+thisItemSelector.className : '';
		}
		
		
		$(selector).changeInputs(function(item, data) {
			console.log(thisItemTag+thisItemClass);
			
			$(item).closest(thisItemTag+thisItemClass).find('[update]:disabled, [save]:disabled').removeAttrib('disabled');
		}, ops.exceptions);
		
		
		// Добавить запись
		$('body').off(tapEvent, ops.addSelector).on(tapEvent, ops.addSelector, function() {
			addRow();
		});

		// Автоматическое добавление одной записи
		if (ops.autoAdd) {
			addRow();
		}



		function addRow() {
			getAjaxHtml(functions+'add', ops.data.add, function(html, stat) {
				if (typeof ops.before.add == 'function') ops.before.add();
				if (!getListStat) {
					$(selector).children().first().remove();
					thisItemSelector = $(html)[0],
					thisItemTag = thisItemSelector && thisItemSelector.localName,
					thisItemClass = thisItemSelector.className ? '.'+thisItemSelector.className : '';
					if (!stat) $(selector).html(ops.emptyList);
					else $(selector).html(html);
					getListStat = true;
					$(selector).children().first().find('[save]').setAttrib('disabled');
					if (typeof ops.confirms.add == 'function') ops.confirms.add($(selector).children().first());
				} else {
					if (ops.listDirection == 'bottom') {
						if (!stat) $(selector).append(ops.emptyList);
						else $(selector).append(html);
						$(selector).children().last().find('[save]').setAttrib('disabled');
						if (typeof ops.confirms.add == 'function') ops.confirms.add($(selector).children().last());
					} else if (ops.listDirection == 'top') {
						if (!stat) $(selector).prepend(ops.emptyList);
						else $(selector).prepend(html);
						$(selector).children().first().find('[save]').setAttrib('disabled');
						if (typeof ops.confirms.add == 'function') ops.confirms.add($(selector).children().first());
					}
				}
			});
		}


		// Сохранить запись
		$(selector).on(tapEvent, '[save]', function() {
			if (typeof ops.before.save == 'function') ops.before.save();
			var thisItem = this,
				thisItemSelector = $(thisItem).closest(thisItemTag+thisItemClass),
				countRows = $(selector).find('tr').length,
				itemIndex = $(thisItemSelector).index(),
				thisItemSort = (ops.listDirection == 'bottom') ? itemIndex : (-itemIndex + countRows),
				//sf = ops.saveListItem.substr(0, 1) != '/' ? '/'+ops.saveListItem : ops.saveListItem,
				fields = {},
				fieldsToItem = {};
				
			$(thisItemSelector).formSubmit({
				returnFields: function(f) {
					$(thisItemSelector).find('input[name], textarea[name], select[name]').each(function(e) {
						var name = $(this).attr('name'),
							val = (['checkbox', 'radio'].indexOf(this.type) != -1) ? ($(this).is(':checked') ? 1 : 0) : $(this).val(),
							text = this.type == 'select-one' ? $(this).val() : ((['checkbox', 'radio'].indexOf(this.type) != -1) ? ($(this).is(':checked') ? 1 : 0) : $(this).val());
						fields[name] = val;
						fieldsToItem[name] = text;
					});

					if (ops.sortField) {
						fields[ops.sortField] = thisItemSort;
						fieldsToItem[ops.sortField] = thisItemSort;
					}

					getAjaxHtml(functions+'save', $.extend(ops.data.save, {fields: fields, fields_to_item: fieldsToItem}), function(html, saveStat) {
						if (saveStat) {
							$(thisItemSelector).replaceWith(function() {
								return html.replace(/(update="\d+")/, '$1 disabled');
							});
							notify('Запись успешно сохранена!');
							$(thisItemSelector).find('.changed').removeClass('changed');
							if (typeof ops.confirms.save == 'function') ops.confirms.save(thisItemSelector, fieldsToItem);
						} else {
							notify('Не удалось сохранить запись!', 'error');
						}
					});
				},
				formError: function(errData) {
					if (typeof ops.errorFields == 'function') ops.errorFields(thisItemSelector, errData);
				}
			});
		});



		// Обновить запись
		$(selector).on(tapEvent, '[update]', function() {
			if (typeof ops.before.update == 'function') ops.before.update();
			var thisItem = this,
				thisId = $(thisItem).attr('update'),
				thisItemSelector = $(this).closest(thisItemTag+thisItemClass),
				thisItemSort = $(thisItemSelector).index(),
				fields = {};

			$(thisItemSelector).formSubmit({
				returnFields: function(f) {
					$.each(f, function(k, i) {
						fields[i.name] = i.value;
					});

					/*if (ops.sortField) {
						fields[ops.sortField] = thisItemSort;
					}*/

					$.post(functions+'update', $.extend(ops.data.update, {id: thisId, fields: fields}), function(response) {
						if (response) {
							notify('Запись успешно обновлена!');
							$(thisItem).setAttrib('disabled');
							$(thisItemSelector).find('.changed').removeClass('changed');
							if (typeof ops.confirms.update == 'function') ops.confirms.update(thisItemSelector, fields);
						} else {
							notify('Не удалось сохранить запись!', 'error');
						}
					}, 'json').fail(function(e) {
						notify('Системная ошибка!', 'error');
						showError(e);
					});
				},
				formError: function(errData) {
					if (typeof ops.errorFields == 'function') ops.errorFields(thisItemSelector, errData);
				}
			});
		});



		// Удалить запись
		$(selector).on(tapEvent, '[remove]', function() {
			if (typeof ops.before.remove == 'function') ops.before.remove();
			var thisId = $(this).attr('remove'),
				thisItem = $(this).closest(thisItemTag+thisItemClass);

			// Удалить несохраненную запись
			if (!thisId) {
				$(thisItem).remove();
				notify('Запись удалена!', 'info');
				if ($(selector).find(thisItemTag+thisItemClass).length == 0) {
					$(selector).html(ops.emptyList);
					getListStat = false;
				}
				return true;
			}

			function removeRow() {
				$.post(functions+'remove', $.extend(ops.data.remove, {id: thisId}), function(response) {
					if (response) {
						$(thisItem).remove();
						notify('Запись удалена!', 'info');
						if ($(selector).find(thisItemTag+thisItemClass).length == 0) {
							$(selector).html(ops.emptyList);
							getListStat = false;
						}
						if (typeof ops.confirms.remove == 'function') ops.confirms.remove(thisItem);
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
						title: 'Удалить запись|4',
						width: 400,
						html: typeof ops.removeConfirm == 'string' ? ops.removeConfirm : '<p class="center red strong">Вы действительно хотите удалить запись?</p>',
						buttons: [{id: 'removeConfY', title: 'Удалить'}],
						closePos: 'left',
						closeButton: 'Отмена',
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
			getAjaxHtml(functions+'get', $.extend(initParams, {where: []}), function(html, getListStat) {
				if (!getListStat) $(selector).html(ops.emptyList);
				else $(selector).html(html);
				$(selector).find('[update]').setAttrib('disabled');
			});
		};


		// before after none both
		obj.search = function(field, search, place) {
			getAjaxHtml(functions+'get', $.extend(initParams, {field: field, search: search, place: place}), function(html, getListStat) {
				if (!getListStat) $(selector).html(ops.emptyList);
				else $(selector).html(html);
				$(selector).find('[update]').setAttrib('disabled');
			});
		};


		// where: метод (where) => [условие => значение]
		obj.where = function(where) {
			getAjaxHtml(functions+'get', $.extend(initParams, {where: where}), function(html, getListStat) {
				if (!getListStat) $(selector).html(ops.emptyList);
				else $(selector).html(html);
				$(selector).find('[update]').setAttrib('disabled');
			});
		};





	}, function() {
		_getListActions();
		if (typeof callback == 'function') {
			callback(obj);
		}
	});
};

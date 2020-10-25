<div class="section" id="sectionFilemanager">
	<div class="section_title">
		<h2>Менеджер файлов</h2>
	</div>

	<div class="row no-gutters">
		<div class="col-auto">
			<div class="filemanager__block filemanager__dirs">
				<div class="filemanager__buttons mb-3">
					<button id="newFolder" title=""><i class="fa fa-plus"></i></button>
					<button disabled id="editFolder" title=""><i class="fa fa-pencil-square-o"></i></button>
					<button disabled id="removeFolder" title=""><i class="fa fa-trash"></i></button>
					<input type="hidden" id="currentDir" value="">
				</div>
				<div class="filemanager__content filemanager__content_dirs">
					<ul class="filemanager__dirstree noselect" id="filemanagerDirs"></ul>
				</div>
			</div>
		</div>
		<div class="col">
			<div class="filemanager__block filemanager__files">
				<div class="filemanager__buttons mb-3">
					<form hidden id="fileUploadForm" enctype="multipart/form-data" autocomplete="off">
						<input type="hidden" name="filemanager_path" id="filemanagerFormPath" value="">
						<input type="hidden" id="hiddenSizeWidth" name="size[width]" value="">
						<input type="hidden" id="hiddenSizeHeight" name="size[height]" value="">
						<input type="file" name="filemanager_files[]" multiple>
					</form>
					<button id="fileUploadFormButton" disabled title=""><i class="fa fa-plus"></i></button>
					<button id="setWidthHeight" disabled title=""><i class="fa fa-crop"></i></button>
					<button id="replaceFiles" disabled title=""><i class="fa fa-retweet"></i></button>
					<button id="removeFiles" disabled title=""><i class="fa fa-trash"></i></button>
					<p style="font-size: 14px; margin-left: 10px; display: inline-block;" id="setWidthHeightInfo"></p>
				</div>
				<div class="filemanager__content filemanager__content_files noselect" id="filemanagerContentFiles"><p class="empty center">Выберите раздел</p></div>
			</div>
		</div>
	</div>	
</div>


		


<script type="text/javascript"><!--
$(document).ready(function() {
	function renderDirs(callback, newPath) {
		var currentDir = $('#currentDir').val();
		getAjaxHtml('filemanager/dirs_get', {current_dir: currentDir}, function(html) {
			$('#filemanagerDirs').html(html);
			if (newPath) $('#filemanagerDirs').find('[directory="'+newPath+'"]').addClass('active');
			if (callback && typeof callback == 'function') callback();
		});
	}
	
	renderDirs();
		
	
	$('#filemanagerDirs').on(tapEvent, '[directory]:not(.disabled):not(.active)', function() {
		var thisDirectory = $(this).attr('directory'); 
		$('#filemanagerDirs').find('[directory]').removeClass('active');
		$(this).addClass('active');
		$('#removeFiles, #replaceFiles').prop('disabled', true);
		$('#editFolder, #removeFolder').prop('disabled', false);
		$('#currentDir').val(thisDirectory);
		
		$('#filemanagerFormPath').val(thisDirectory);
		getAjaxHtml('filemanager/files_get', {directory: thisDirectory}, function(html) {
			$('#filemanagerContentFiles').html(html);
			$('#fileUploadFormButton, #setWidthHeight').prop('disabled', false);
		});
	});
	
	
	
	
	
	$('#newFolder').on(tapEvent, function() {
		popUp({
			title: 'Новая директория',
		    width: 500,
		    buttons: [{id: 'addFolder', title: 'Добавить'}],
		    closeButton: 'Отмена',
		}, function(newFolderWin) {
			newFolderWin.wait();
			getAjaxHtml('filemanager/dirs_new', function(html) {
				newFolderWin.setData(html);
				$('#addFolder').on(tapEvent, function() {
					newFolderWin.wait();
					sendFormData('#newFolderForm', {
						url: 'filemanager/dirs_add',
						success: function(response) {
							if (response == 5) {
								notify('Ошибка! Недопустимое название!', 'error');
								newFolderWin.wait(false);
							} else if (response == 4) {
								notify('Ошибка! Пустое название!', 'error');
								newFolderWin.wait(false);
							} else if (response == 3) {
								notify('Ошибка! Название содержит недопустимые символы!', 'error');
								newFolderWin.wait(false);
							} else if (response == 2) {
								notify('Такая директория уже существует!', 'info');
								newFolderWin.wait(false);
							} else if (response == 1) {
								notify('Директория успешно создана!');
								renderDirs(function() {
									newFolderWin.close();
								});
							} else {
								notify('Ошибка создания директории!', 'error');
							}
						},
						error: function() {
							newFolderWin.wait(false);
						}
					});
				});
			}, function() {
				newFolderWin.wait(false);
			});
		});
	});
	
	
	
	
	
	$('#editFolder').on(tapEvent, function() {
		var currentFolder = $('#filemanagerDirs').find('[directory].active');
		if (currentFolder.length == 0) {
			notify('Не выбрано ни одной директории!', 'error');
			return false;
		} else {
			var dirPath = $(currentFolder).attr('directory'),
				dirName = $(currentFolder).text();
		}
		
		popUp({
			title: 'Редиктирование директории',
		    width: 500,
		    buttons: [{id: 'updateDir', title: 'Применить'}],
		    closeButton: 'Отмена',
		}, function(updateFolderWin) {
			updateFolderWin.wait();
			getAjaxHtml('filemanager/dirs_edit', {
				name: dirName,
				path: dirPath
			}, function(html) {
				updateFolderWin.setData(html);
				$('#updateDir').on(tapEvent, function() {
					sendFormData('#editFolderForm', {
						url: 'filemanager/dirs_update',
						success: function(newName) {
							if (newName == 3) {
								notify('Ошибка! Название содержит недопустимые символы!', 'error');
							}else if (newName) {
								notify('Директория успешно переименована!');
								
								dirPath = dirPath.split('/');
								dirPath[dirPath.length - 1] = newName;
								dirPath = dirPath.join('/');
								
								
								renderDirs(function() {
									updateFolderWin.close();
								}, dirPath);
							} else {
								notify('Ошибка переименования директории!', 'error');
							}
						}
					});
				});
			}, function() {
				updateFolderWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	$('#removeFolder').on(tapEvent, function() {
		var currentFolder = $('#filemanagerDirs').find('[directory].active');
		if (currentFolder.length == 0) {
			notify('Не выбрано ни одной директории!', 'error');
			return false;
		} else {
			var dirPath = $(currentFolder).attr('directory');
		}
		
		popUp({
			title: 'Удаление директории',
		    width: 500,
		    height: false,
		    html: '<p class="center">Вы действительно хотите удалить директорию?</p> <p class="center">Внимание! Это повлечет за собой удаление всех файлов, находящихся внутри категории!</p>',
		    buttons: [{id: 'removeDir', title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(removeDirWin) {
			$('#removeDir').on(tapEvent, function() {
				removeDirWin.wait();
				$.post('/filemanager/dirs_remove', {path: dirPath}, function(response) {
					if (response) {
						notify('Директория успешно удалена!');
						renderDirs(function() {
							$('#editFolder, #removeFolder').prop('disabled', true);
							removeDirWin.close();
							$('#fileUploadFormButton, #setWidthHeight').prop('disabled', true);
							$('#filemanagerContentFiles').html('<p class="empty center">Выберите раздел</p>');
						});
					} else {
						notify('Ошибка удаления директории!', 'error');
					}
				}, 'json').always(function() {
					removeDirWin.wait(false);
				}).fail(function(e) {
					notify('Системная ошибка!', 'error');
					showError(e);
				});
			});	
		});
	});
	
	
	
	
	

	
	
	//-------------------------------------------------------------------------
	
	
	
	
	
	
	var selectedFiles = [];
	$('#filemanagerContentFiles').selectable({
		classes: {
			"ui-selecting": "selected",
			"ui-selected": "selected"
		},
		distance: 0,
		filter: ".file",
		stop: function(event, ui) {
			var sf = $('#filemanagerContentFiles').find('.file.selected');
				selectedFiles = [];
			
			if (sf.length > 0) {
				$.each(sf, function(k, file) {
					var thisFileDir = $(file).attr('dirfile');
					selectedFiles.push(thisFileDir);
				});
				$('#removeFiles, #replaceFiles').removeAttrib('disabled');
			} else {
				$('#removeFiles, #replaceFiles').setAttrib('disabled');
			}
		}
	});
	
	
	
	
	$('#removeFiles').on(tapEvent, function() {
		popUp({
			title: 'Удалить файлы',
		    width: 500,
		    html: '<p class="center">Вы действительно хотите удалить файлы?</p>',
		    buttons: [{id: 'deleteFiles', title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(deleteFilesWin) {
			$('#deleteFiles').on(tapEvent, function() {
				deleteFilesWin.wait();
				$.post('/filemanager/files_delete', {files: selectedFiles}, function(response) {
					$('#filemanagerContentFiles').find('.file.ui-selected').remove();
					$('#removeFiles, #replaceFiles').prop('disabled', true);
					notify('Файлы успешно удалены!', 'info');
					deleteFilesWin.close();
					if ($('#filemanagerContentFiles').find('.file').length == 0) {
						$('#filemanagerContentFiles').html('<p class="empty center">Нет данных</p>');
					}
				}, 'json').always(function() {
					deleteFilesWin.wait(false);
				}).fail(function(e) {
					notify('Системная ошибка!', 'error');
					showError(e);
				});
			});
		});	
	});
	
	
	
	
	
	
	$('#replaceFiles').on(tapEvent, function() {
		var currentFolder = $('#filemanagerDirs').find('[directory].active');
		if (currentFolder.length == 0) {
			notify('Не выбрано ни одной директории!', 'error');
			return false;
		} else {
			var dirPath = $(currentFolder).attr('directory');
		}
		popUp({
			title: 'Переместить файлы',
		    width: 500,
		    buttons: [{id: 'getReplaceFiles', title: 'Переместить'}],
		    closeButton: 'Отмена',
		}, function(replaceFilesWin) {
			replaceFilesWin.wait();
			getAjaxHtml('filemanager/files_replace', {currentdir: dirPath}, function(html) {
				replaceFilesWin.setData(html);
			}, function() {
				replaceFilesWin.wait(false);
			});
			
			$('#getReplaceFiles').on(tapEvent, function() {
				replaceFilesWin.wait();
				$('#filemanagerDirs').find('span').addClass('disabled');
				$('#removeFiles, #replaceFiles, #newFolder, #editFolder, #removeFolder, #fileUploadFormButton, #setWidthHeight').prop('disabled', true);
				sendFormData('#replaceFilesForm', {
					url: 'filemanager/files_replace',
					params: {
						replace: 1,
						files: JSON.stringify(selectedFiles)
					},
					success: function(response) {
						if (response) {
							var activeDirectory = $('#filemanagerDirs').find('[directory].active').attr('directory');
							getAjaxHtml('filemanager/files_get', {directory: activeDirectory}, function(html) {
								$('#filemanagerContentFiles').html(html);
								$('#newFolder, #editFolder, #removeFolder, #fileUploadFormButton, #setWidthHeight').prop('disabled', false);
								$('#filemanagerDirs').find('span').removeClass('disabled');
								replaceFilesWin.close();
							});
						} else {
							notify('Ошибка перемещения файлов', 'error');
						}
					},
					complete: function() {
						replaceFilesWin.wait(false);
					}
				});
			});
		});	
	});
	
	
	
	
	
	
	
	
	
	
	
	$('#setWidthHeight').on(tapEvent, function() {
		var hasImgWidth = $('#hiddenSizeWidth').val() || 0,
			hasImgHeight = $('#hiddenSizeHeight').val() || 0;
		
		popUp({
			title: 'Задать размеры изображений',
		    width: 400,
		    buttons: [{id: 'setWidthHeightButton', title: 'Задать'}, {id: 'unsetWidthHeightButton', title: 'Сбросить'}],
		    closeButton: 'Отмена',
		}, function(setWidthHeightWin) {
			setWidthHeightWin.wait();
			getAjaxHtml('filemanager/set_width_height', {width: hasImgWidth, height: hasImgHeight}, function(html) {
				setWidthHeightWin.setData(html);
				
				$('#setWidthHeightButton').on(tapEvent, function() {
					$('#sectionWait').addClass('visible filemanager');
					
					$('#hiddenSizeWidth').val($('#imageWidthField').val());
					$('#hiddenSizeHeight').val($('#imageHeightField').val());
				
					var sW = $('#imageWidthField').val() != 0 ? $('#imageWidthField').val() : '(не задан)',
						sH = $('#imageHeightField').val() != 0 ? $('#imageHeightField').val() : '(не задан)',
						sText = 'Размеры для изображений: '+sW+' X '+sH;
						
					$('#setWidthHeightInfo').html(sText);
					notify('Размеры для изображений заданы!');
					setWidthHeightWin.close();
					$('#fileUploadFormButton').trigger(tapEvent);
					setTimeout(function() {});
					$('#sectionWait').removeClass('visible filemanager');
				});
				
				$('#unsetWidthHeightButton').on(tapEvent, function() {
					$('#hiddenSizeWidth').val('');
					$('#hiddenSizeHeight').val('');
					notify('Размеры для изображений сброшены!');
					$('#setWidthHeightInfo').html('');
					setWidthHeightWin.close();
				});
				
			}, function() {
				setWidthHeightWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	$('#fileUploadFormButton').on(tapEvent, function() {
		$('#fileUploadForm').find('input[type="file"]').trigger('click');
	});
	
	
	$('#fileUploadForm').find('input[type="file"]').on('change', function() {
		$('#sectionWait').addClass('visible filemanager');
		$('#removeFiles, #replaceFiles, #newFolder, #editFolder, #removeFolder, #fileUploadFormButton, #setWidthHeight').prop('disabled', true);
		$('#filemanagerDirs').find('span').addClass('disabled');
		sendFormData('#fileUploadForm', {
			url: 'filemanager/files_upload',
			success: function(response) {
				if (response == 2) {
					console.log('2');
				} else if (response == 1) {
					notify('Файлы успешно загружены!');
				} else if (response.error) {
					notify('Ошибка загрузки файлов!', 'error');
				}
			},
			complete: function() {
				var activeDirectory = $('#filemanagerDirs').find('[directory].active').attr('directory');
				getAjaxHtml('filemanager/files_get', {directory: activeDirectory}, function(html) {
					$('#filemanagerContentFiles').html(html);
					$('#removeFiles, #replaceFiles, #newFolder, #editFolder, #removeFolder, #fileUploadFormButton, #setWidthHeight').prop('disabled', false);
					$('#filemanagerDirs').find('span').removeClass('disabled');
					$('#sectionWait').removeClass('visible filemanager');
					$("#fileUploadForm")[0].reset();
				});
			}
		});
	});
});
//--></script>
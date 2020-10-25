<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Filemanager extends MY_Controller {
	
	private $filesPath = '.'.DIRECTORY_SEPARATOR.'public'.DIRECTORY_SEPARATOR.'filemanager'.DIRECTORY_SEPARATOR;
	private $hideDirs = 'thumbs';
	private $thumbsWidth = 150;
	private $thumbsHeight = 150;
	
	
	public function __construct() {
		parent::__construct();
		$this->load->helper(['directory', 'string', 'text']);
	}
	
	
	
	/**
	 * Получить дерево директорий
	 * @param 
	 * @return 
	 */
	public function dirs_get() {
		$currentDir = $this->input->post('current_dir') ?: false;
		$dirsData = directory_map($this->filesPath, 0);
		$dirsData = clearDirs($dirsData, $this->hideDirs);
		echo $this->twig->render('views/admin/render/filemanager/dirs.tpl', ['dirs' => $dirsData, 'currentdir' => $currentDir]);
	}
	
	
	
	/**
	 * Новая директория
	 * @param 
	 * @return 
	 */
	public function dirs_new() {
		$dirsData = directory_map($this->filesPath, 0);
		$dirsData = clearDirs($dirsData, $this->hideDirs);
		echo $this->twig->render('views/admin/render/filemanager/dirs_new.tpl', ['dirs' => $dirsData]);
	}
	
	
	
	
	
	/**
	 * Добавить новую директорию
	 * @param 
	 * @return 
	 */
	public function dirs_add() {
		$data = $this->input->post();
		if (!is_dir($this->filesPath.$this->hideDirs)) mkdir($this->filesPath.$this->hideDirs); // Если нет директории thumbs - то создать ее
		if (trim($data['title']) == 'thumbs') exit('5'); // Нельзя назвать
		if (trim($data['title']) == '') exit('4'); // Пустое название
		if (preg_match('/[\\\|\/]/ui', trim($data['title']))) exit('3'); // Название содержит недопустимые символы
		
		$dirName = encodeDirsFiles($data['title']);
		$path = $data['path'].DIRECTORY_SEPARATOR;
		
		if (is_dir($this->filesPath.$path.$dirName)) exit('2'); // такая директория уже есть
		if (!mkdir($this->filesPath.$path.$dirName, 0777)) exit('0');
		if (!mkdir($this->filesPath.$this->hideDirs.DIRECTORY_SEPARATOR.$path.$dirName, 0777)) exit('0');
		echo 1;
	}
	
	
	
	/**
	 * Редактирование директории
	 * @param 
	 * @return 
	 */
	public function dirs_edit() {
		$data = $this->input->post();
		$dirsData = directory_map($this->filesPath, 0);
		$dirsData = clearDirs($dirsData, $this->hideDirs);
		echo $this->twig->render('views/admin/render/filemanager/dirs_edit.tpl', ['dirs' => $dirsData, 'name' => $data['name'], 'path' => $data['path']]);
	}
	
	
	
	/**
	 * Обновить директорию
	 * @param 
	 * @return 
	 */
	public function dirs_update() {
		$data = $this->input->post();
		
		/*if ($data['oldpath'] != $data['path']) {
			copy($this->filesPath.$data['oldpath'].'/*', $this->filesPath.$data['path']);
		}*/
		
		$pathWithoutName = explode(DIRECTORY_SEPARATOR, $data['oldpath']);
		unset($pathWithoutName[count($pathWithoutName) - 1]);
		$pathWithoutName = implode(DIRECTORY_SEPARATOR, $pathWithoutName);
		
		if (preg_match('/[\\\|\/]/ui', trim($data['name']))) exit('3'); // Название содержит недопустимые символы
		
		$oldName = encodeDirsFiles($data['oldname']);
		$newName = encodeDirsFiles($data['name']);
		
		if ($oldName != $newName) {
			
			if (!rename($this->filesPath.$pathWithoutName.$oldName, $this->filesPath.$pathWithoutName.$newName)) exit('0');
			if (!rename($this->filesPath.$this->hideDirs.DIRECTORY_SEPARATOR.$pathWithoutName.$oldName, $this->filesPath.$this->hideDirs.DIRECTORY_SEPARATOR.$pathWithoutName.$newName)) exit('0');
		}
		echo json_encode($newName);
	}
	
	
	
	/**
	 * Удалить директорию
	 * @param 
	 * @return 
	 */
	public function dirs_remove() {
		$path = $this->filesPath.$this->input->post('path');
		$thumbsPath = $this->filesPath.$this->hideDirs.DIRECTORY_SEPARATOR.$this->input->post('path');
		
		function removeDirectory($dir) {
			if ($objs = glob($dir.DIRECTORY_SEPARATOR."*")) {
			   foreach($objs as $obj) {
			     is_dir($obj) ? removeDirectory($obj) : unlink($obj);
			   }
			}
			return rmdir($dir);
		}
		
		if (removeDirectory($path) && removeDirectory($thumbsPath)) exit('1');
		echo 0;
	}
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список файлов
	 * @param 
	 * @return 
	 */
	public function files_get() {
		if (!$directory = $this->input->post('directory')) return false;
		$fileTypes = $this->input->post('filetypes') ? explode('|', $this->input->post('filetypes')) : false;
		$dirFiles = directory_map($this->filesPath.$directory, 1);
		
		$filesData = [];
		if ($dirFiles) {
			foreach ($dirFiles as $file) {
				if (strpos($file, '\\') || strpos($file, '/') || strpos($file, DIRECTORY_SEPARATOR)) continue;
				$fData = explode('.', $file);
				$e = array_pop($fData);
				$n = implode('.', $fData);
				if ($fileTypes && !in_array($e, $fileTypes)) continue;
				
				$filesData[] = [
					'src'	=> $directory.DIRECTORY_SEPARATOR.$file,
					'name'	=> decodeDirsFiles($n).'.'.$e
				];
			}
		}
		
		echo $this->twig->render('views/admin/render/filemanager/files.tpl', ['files' => $filesData]);
	}
	

	
	
	/**
	 * Переместить файлы
	 * @param 
	 * @return 
	 */
	public function files_replace() {
		$replace = $this->input->post('replace') ?: false;
		if ($replace) {
			$data = $this->input->post();
			
			$errors = [];
			if ($filesData = json_decode($data['files'], true)) {
				foreach ($filesData as $file) {
					$fileName = explode(DIRECTORY_SEPARATOR, $file);
					$fileName = $fileName[count($fileName)-1];
					
					
					
					
					
					
					
					
					if (!copy($this->filesPath.$file, $this->filesPath.$data['path'].DIRECTORY_SEPARATOR.$fileName)) {
					    $errors['copy'][] = $file;
					} else {
						if (!unlink($this->filesPath.$file)) {
							$errors['remove'][] = $file;
						}
					}
					
					if (!copy($this->filesPath.$this->hideDirs.DIRECTORY_SEPARATOR.$file, $this->filesPath.$this->hideDirs.DIRECTORY_SEPARATOR.$data['path'].DIRECTORY_SEPARATOR.$fileName)) {
					    $errors['copy_thumb'][] = $file;
					} else {
						if (!unlink($this->filesPath.$this->hideDirs.DIRECTORY_SEPARATOR.$file)) {
							$errors['remove_thumb'][] = $file;
						}
					}
				}
			}
			
			if ($errors) echo json_encode($errors);
			else echo 1;
		} else {
			$currentDir = $this->input->post('currentdir');
			$dirsData = directory_map($this->filesPath, 0);
			$dirsData = clearDirs($dirsData, $this->hideDirs);
			echo $this->twig->render('views/admin/render/filemanager/files_replace.tpl', ['dirs' => $dirsData, 'currentdir' => $currentDir]);
		}
	}
	
	
	
	
	
	/**
	 * Установить ширину и высоту, которая задается сразу при загрузке
	 * @param 
	 * @return 
	 */
	public function set_width_height() {
		$pData = $this->input->post();
		echo $this->twig->render('views/admin/render/filemanager/set_width_height.tpl', $pData);
	}
	
	
	
	
	/**
	 * Загрузить файл(ы)
	 * @param 
	 * @return 
	 */
	public function files_upload() {
		$path = $this->input->post('filemanager_path');
		$reSize = $this->input->post('size') ?: false;
		$files = $this->input->files('filemanager_files');
		if (!$files) exit('2');
		$files = $this->_reArrayFiles($files);
		$this->load->library(['upload', 'image_lib']);
        
        $errors = [];
        foreach ($files as $k => $file) {
			$fileName = explode('.', $file['name']);
			$e = strtolower(array_pop($fileName));
			$n = implode('.', $fileName);
			$name = encodeDirsFiles($n);
			
        	
        	$this->upload->initialize([
        		'file_name' 	=> $name.'.'.$e,
        		'upload_path' 	=> 'public'.DIRECTORY_SEPARATOR.'filemanager'.DIRECTORY_SEPARATOR.$path,
        		'allowed_types'	=> $this->fileTypes,
        		'overwrite'		=> true,
        		//'max_filename_increment' => 300,
				'quality'		=> '100%',
        	]);
        	

        	//$this->upload->set_allowed_types($this->fileTypes);
        	
        	
        	if ($this->upload->do_upload('filemanager_files[]', $file)) {
        		$uploadData = $this->upload->data();
        		
        		if ($uploadData['is_image'] == 1) { // если загруженный файл - изображение
	        		$cfg['image_library'] = 'gd2';
		        	$cfg['maintain_ratio'] = true;
		        	$cfg['master_dim'] = 'auto'; //auto, width, height
					$cfg['source_image'] = $uploadData['full_path'];
					$cfg['new_image'] = 'public'.DIRECTORY_SEPARATOR.'filemanager'.DIRECTORY_SEPARATOR.'thumbs'.DIRECTORY_SEPARATOR.$path.DIRECTORY_SEPARATOR.$uploadData['file_name'];
					if (!is_dir('public'.DIRECTORY_SEPARATOR.'filemanager'.DIRECTORY_SEPARATOR.'thumbs'.DIRECTORY_SEPARATOR.$path.DIRECTORY_SEPARATOR)) mkdir('public'.DIRECTORY_SEPARATOR.'filemanager'.DIRECTORY_SEPARATOR.'thumbs'.DIRECTORY_SEPARATOR.$path.DIRECTORY_SEPARATOR);
					$cfg['width'] = $this->thumbsWidth;
					$cfg['height'] = $this->thumbsHeight;
					
					$this->image_lib->initialize($cfg);
					if (!$this->image_lib->resize()) toLog($this->image_lib->display_errors());
					
					
					if ($reSize) {
						$this->image_lib->clear();
						$cfgr['image_library'] = 'gd2';
			        	$cfgr['maintain_ratio'] = true;
			        	$cfgr['master_dim'] = 'auto'; //auto, width, height
						$cfgr['source_image'] = $uploadData['full_path'];
						if ($reSize['width']) $cfgr['width'] = $reSize['width'];
						if ($reSize['height']) $cfgr['height'] = $reSize['height'];
						$this->image_lib->initialize($cfgr);
						if (!$this->image_lib->resize()) toLog($this->image_lib->display_errors());
					} else {
						$this->image_lib->clear();
					}
        		}
        		
        	} else {
        		$errors[$k]['error'] = $this->upload->display_errors();
				$errors[$k]['file'] = $file;
        	}
        }
        
        
        if ($errors) exit(json_encode($errors));
        echo 1;
	}
	
	
	
	
	/**
	 * Перестроить массив $_FILES
	 * @param 
	 * @return 
	 */
	private function _reArrayFiles(&$filePost) {
	    $filesArr = [];
	    $file_count = count($filePost['name']);
	    $file_keys = array_keys($filePost);
	    
	    for ($i=0; $i<$file_count; $i++) {
	        foreach ($file_keys as $key) {
	            $filesArr[$i][$key] = $filePost[$key][$i];
	        }
	    }
	    
	    return $filesArr;
	}
		
	
	
	/**
	 * Удалить файлы
	 * @param 
	 * @return 
	 */
	public function files_delete() {
		if (!$files = $this->input->post('files')) exit('0');
		foreach ($files as $file) {
			if (file_exists($this->filesPath.$file)) unlink($this->filesPath.$file);
			if (file_exists($this->filesPath.$this->hideDirs.DIRECTORY_SEPARATOR.$file)) unlink($this->filesPath.$this->hideDirs.DIRECTORY_SEPARATOR.$file);
			
		}
		echo 1;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------ Клиентская часть
	
	
}
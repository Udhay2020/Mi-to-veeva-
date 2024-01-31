#user manual for CLM migrator automation from MI to VEEVA 
#pre requirements :
#we need to have Python3 , nodejs , NPM and  import "os,shutil,webbrowser,zipfile,os,webbrowser,r
#running terminal
# Enter CLM's slide folder path: =>
# Enter veeva library path or  press Enter to use default path:=>place your library path or at variable sourceLibrary place default path and click enter
# choose the necessary action to be performed

import os
import shutil
import webbrowser
import zipfile
import os
import re


def main():


	def deletion(innerSrc,filename,innerFilename):
		if not filename.endswith('.zip'):
			try:
				if(innerFilename == "js" or innerFilename =="javascript"):
					libraryTarget = f"{innerSrc}/{innerFilename}/veeva-library-212.0.100.js"
					print(libraryTarget ,"library added")
					shutil.copyfile(sourceLibrary, libraryTarget)
				if(innerFilename == "Parameters"):
					deletionFilePath = f"{innerSrc}/{innerFilename}"
					shutil.rmtree(deletionFilePath)
				if(innerFilename == "parameters"):
					deletionFilePath = f"{innerSrc}/{innerFilename}"
					shutil.rmtree(deletionFilePath)
				if(innerFilename == "__MACOSX"):
					deletionFilePath = f"{innerSrc}/{innerFilename}"
					shutil.rmtree(deletionFilePath)
				if(innerFilename == "export"):
					deletionFilePath = f"{innerSrc}/{innerFilename}"
					shutil.rmtree(deletionFilePath)
				if(innerFilename == ".DS_Store"):
					deletionFilePath = f"{innerSrc}/{innerFilename}"
					os.remove(deletionFilePath)
				if(innerFilename == "media"):
					innerSrc1 = f"{innerSrc}/{innerFilename}"
					for count1, innerFilename1 in enumerate(os.listdir(innerSrc1)):

						if(innerFilename1 == "images"):
							innerSrc2 = f"{innerSrc1}/{innerFilename1}"

							for count2, innerFilename2 in enumerate(os.listdir(innerSrc2)):
								if os.path.isdir(innerSrc2):
									if(innerFilename2 == "thumbnails"):

										innerSrc3 = f"{innerSrc2}/{innerFilename2}"

										for count3, innerFilename3 in enumerate(os.listdir(innerSrc3)):

											if(innerFilename3 == "200x150.jpg" ):
											
												innerSrc4 = f"{innerSrc3}/{innerFilename3}"
												try:
													shutil.move(innerSrc4, innerSrc)
												except:
													print("Error in moving thumb image=>",innerSrc4)
												finally:
													print("success in file moveing =>",innerSrc3)
													shutil.rmtree(innerSrc3) #Which is THUMBNAIL PATH after image croped so it will remove empty folder



								

			except OSError as e:
				print("Error: %s - %s." % (e.filename, e.strerror))

			finally:
				print("folder structure changed")
		else:
			pass

	def extract_zip(innerSrc):
		folder_name=filename.split(".")[0]
		destination_zip=f"{folder}/{folder_name}"
		if not os.path.exists(destination_zip):
				os.makedirs(destination_zip)
				with zipfile.ZipFile(innerSrc,'r')as zip_ref:
					zip_ref.extractall(destination_zip)
					print("unziping")
		else:
			print("path already exixts")

	def compress_zip(filename,innerSrc):
		for count2, innerFilename in enumerate(os.listdir(innerSrc)):
			allfolders = f"{innerSrc}"
			zip_filename=f'{innerSrc}.zip'
			inside_name_inzip=filename
			folder_to_zip=innerSrc
			folder_contents=allfolders

			# shutil.make_archive(zip_filename , "zip" , allfolders)
			with zipfile.ZipFile(zip_filename, 'w' , zipfile.ZIP_DEFLATED) as zip_f:
				for f,s,fs in os.walk(innerSrc):
					for fn in fs:
						file_path=os.path.join(f,fn)
						arcname=os.path.relpath(file_path , folder_to_zip)
						zip_f.write(file_path, os.path.join(inside_name_inzip , arcname))

	def archive_zip(filename,innerSrc):
		for count2, innerFilename in enumerate(os.listdir(innerSrc)):
			allfolders = f"{innerSrc}"
			zip_filename=f'{innerSrc}'
			shutil.make_archive(zip_filename , "zip" , allfolders)		
	
	def nameing_normal(innerSrc , filename ,innerFilename):
	 #For making index.html file name as folder name :
		# if(innerFilename == "index.html"):
		for count2, innerFilename in enumerate(os.listdir(innerSrc)):
			if innerFilename.endswith('.html'):

				dst = f"{filename}.html"
				src =f"{innerSrc}/{innerFilename}"
				dst =f"{innerSrc}/{dst}"
				os.rename(src, dst)
					
		#To make 200x150.jpg to filename-thumb.png format :
			# if(innerFilename == "200x150.jpg"):
			if innerFilename.endswith('.jpg') or innerFilename.endswith('.png'):
				dst = f"{filename}-thumb.png"
				src =f"{innerSrc}/{innerFilename}"
				dst =f"{innerSrc}/{dst}"
				os.rename(src, dst)

	def index_nameing(innerSrc , filename ,innerFilename):
#To make 200x150.jpg tothumb.png format Index already found :
		for count2, innerFilename in enumerate(os.listdir(innerSrc)):
			if innerFilename.endswith('.jpg') or innerFilename.endswith('.png'):
				dst = f"thumb.png"
				src =f"{innerSrc}/{innerFilename}"
				dst =f"{innerSrc}/{dst}"
				os.rename(src, dst)

	def find_Replace(innerSrc,innerFilename):

		if innerFilename.endswith(".html"):
			search_text = "</head>"
			# creating a variable and storing the text that we want to add  
			replace_text = """	 
	<script src="js/veeva-library-212.0.100.js"></script>
	<script>
		//Override navigation code to make the package complatable for Veeva
		window = {};
		window.parent = {};
		window.parent.PDFHelper = {};
		window.parent.navigateToSequence = function (value) {
			com.veeva.clm.gotoSlide(value + ".zip");
		};
		window.parent.goPreviousSequence = function () {
			com.veeva.clm.prevSlide();
		};
		window.parent.goNextSequence = function () {
			com.veeva.clm.nextSlide();
		};
		window.parent.PDFHelper.OpenPDF = function (value) {
			window.open(value);
		};
	</script>
	</head>
"""
									# Opening our text file in read only mode using the open() function 
			with open(f'{innerSrc}/{innerFilename}', 'r') as file: 

				data = file.read() 

				# Searching and replacing the text using the replace() function 
				data = data.replace(search_text, replace_text) 

			# Opening our text file in write only mode to write the replaced content 
			with open(f'{innerSrc}/{innerFilename}', 'w') as file: 

				# Writing the replaced data in our text file 
				file.write(data) 

			print("Script replaced") 

	def revert_index_thumb(innerSrc,filename,innerFilename):
		try:
			if innerFilename.endswith('.png') or innerFilename.endswith('.jpg') : 
				dst = f"thumb.png"
				src =f"{innerSrc}/{innerFilename}"
				dst =f"{innerSrc}/{dst}"
				os.rename(src, dst)
			if innerFilename.endswith('.html'):
				dst ='index.html'
				src =f"{innerSrc}/{innerFilename}"
				dst =f"{innerSrc}/{dst}"	
				os.rename(src, dst)
		except  OSError as error:
			print(error)
		finally:
			print("renamed")
		
	def makeDir(innerSrc,new_foldername):
		# os.mkdir() method to make js folder or any if not found	# Parent Directory path
		directory = new_foldername
		parent_dir = innerSrc +"/"
		path = os.path.join(parent_dir, directory)
		try: 
			os.mkdir(path) 
		except OSError as error: 
			print(error)
		print("Directory '% s' created" % directory)

	def rename_folders(innerSrc,filename,finding_name,replacing_name):
		replacetxt=filename.replace(finding_name,replacing_name)
		newname= f"{folder}/{replacetxt}"
		os.rename(innerSrc,newname)
		innerSrc=newname

	def delete_zip(innerSrc):
			try:
				
				if(innerSrc):
					deletionFilePath = f"{innerSrc}"
					os.rmdir(deletionFilePath)
				
			except OSError as e:
				print("Error: %s - %s." % (e.filename, e.strerror))
				pass

			finally:
				print("folder structure changed")
	

	while True:
		raw_folder=input("Enter CLM's slide folder path:")
		folder=raw_folder.replace("\\","/")

		raw_sourceLibrary=input("Enter veeva library path or  press Enter to use default path:")
		sourceLibrary=raw_sourceLibrary.replace("\\","/")
		if sourceLibrary =="":
		#Here place the default path with /
			sourceLibrary="C:/7days/CLM folder Migrator/libraray/veeva-library-212.0.100.js"

		print("""
1=> Default unziping, folder structure migration , folder.html & thumb naming:
2=> Unziping, folder structure as Index.html & thumb.png naming:
3=> Revert from folder.html & thumb name:
4=> Default unziping, folder structure migration , folder.html & thumb naming with Veeva code to replacing </head> with gotoSlide(value +"zip):
5=> Make custom folder and place library:
6=> Find and replace some unsupported veeva character in folder name or shorting:
7=> Compress as Zip
8=> Archive as a Zip
9=> Delete all Zip 
99=>unzip file
0=> Opener of all html files for checking:
Press any other to exit""")


		typeOfMigration=int(input("Yours type of migration:"))



		if typeOfMigration=="":
			typeOfMigration=1
		
		if   typeOfMigration ==1:
			for count, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
				extract_zip(innerSrc)

			for count, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"

				try:
					if not filename.endswith('.zip'):	
						for count1, innerFilename in enumerate(os.listdir(innerSrc)):
							deletion(innerSrc,filename,innerFilename)							
							nameing_normal(innerSrc , filename ,innerFilename)
				except NotADirectoryError as e:
					print(e)
				finally:
					continue

		elif typeOfMigration ==2:

				for count, filename in enumerate(os.listdir(folder)):
					innerSrc = f"{folder}/{filename}"
					extract_zip(innerSrc)

				for count, filename in enumerate(os.listdir(folder)):
					innerSrc = f"{folder}/{filename}"

					try:
						if not filename.endswith('.zip'):	
							for count1, innerFilename in enumerate(os.listdir(innerSrc)):
								deletion(innerSrc,filename,innerFilename)							
								index_nameing(innerSrc , filename ,innerFilename)
					except NotADirectoryError as e:
						print(e)
					finally:
						continue
		elif typeOfMigration ==3:
			for count, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
			for count1, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
				for count2, innerFilename in enumerate(os.listdir(innerSrc)):
					revert_index_thumb(innerSrc,filename,innerFilename)

		elif typeOfMigration ==4:
			for count, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
				extract_zip(innerSrc)

			for count1, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
				for count2, innerFilename in enumerate(os.listdir(innerSrc)):
					deletion(innerSrc,filename,innerFilename)
					index_nameing(innerSrc , filename ,innerFilename)
					find_Replace(innerSrc,innerFilename)

		elif typeOfMigration ==5:
			new_foldername=input("folder name would you like to create")
			for count, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"

			for count1, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
				makeDir(innerSrc,new_foldername)
		
		elif typeOfMigration ==6:
			finding_name=input("folder name would you like find:")
			replacing_name=input("folder name would you like replace:")
			for count, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"

			for count1, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
				print(innerSrc)
				rename_folders(innerSrc,filename,finding_name,replacing_name)
		elif typeOfMigration ==7:
			for count, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
				compress_zip(filename,innerSrc)

		elif typeOfMigration ==8:
			for count, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
				archive_zip(filename,innerSrc)

		elif typeOfMigration ==9:

			for count1, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
				if filename.endswith('.zip'):
						os.remove(innerSrc)
						print("zip files removed")
		if   typeOfMigration ==1:
			for count, filename in enumerate(os.listdir(folder)):
				innerSrc = f"{folder}/{filename}"
				extract_zip(innerSrc)

			


		elif typeOfMigration ==0:

			def customsort(s):
				parts = re.split(r"(\d+)" , s )
				return [int(part) if part.isdigit() else part for part in parts]

			
			numberOfFiles = os.listdir(folder); 
			a= sorted(numberOfFiles , key = customsort) ;
			print(a)
			#  here list we need to split it ups
			for count, filename in enumerate(a):
				innerSrc = f"{folder}/{filename}"
				if not filename.endswith('.zip'):
					for count1, innerFilename in enumerate(os.listdir(innerSrc)):
						# print(innerFilename)
						if innerFilename.endswith('.html'):
							index_path=f"{innerSrc}/{innerFilename}"
							webbrowser.open_new_tab(index_path)
						else:
							continue

		else:
			break


	

				
if __name__ == '__main__':
		main()










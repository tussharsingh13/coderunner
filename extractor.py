from threading import Thread
import boto
import os
import subprocess

if __name__ == '__main__':
	LOCAL_PATH = 'codechecker/'
	s3 = boto.connect_s3('access key','secretid')
	bucket = s3.get_bucket('coderunnerdetails')
	for key in bucket.list():
		print key.name.encode('utf-8')
		try:
			res = key.get_contents_to_filename(LOCAL_PATH+key.name)
			filename = key.name.encode('utf-8')
			formatcheck = filename.split('.')
			namesplit = filename.split('#')
			if formatcheck[len(formatcheck) - 1] == "txt":
				contestcode = namesplit[0]

				path = LOCAL_PATH + contestcode
				subprocess.call(["mkdir", path])
				subprocess.call(["mv", LOCAL_PATH+key.name,LOCAL_PATH+contestcode+"/"+key.name])
				
			else:
				problemcode = namesplit[0]
				contestcode = namesplit[1]
				path = LOCAL_PATH + "/" + contestcode + "/" + problemcode
				subprocess.call(["mkdir", path])
				subprocess.call(["mkdir", path+"/compilation_error_files"])
				subprocess.call(["mkdir", path+"/diff_directory"])
				subprocess.call(["mkdir", path+"/generated_output"])
				subprocess.call(["mkdir", path+"/log_files"])
				subprocess.call(["mkdir", path+"/user_codes"])
				
				subprocess.call(["unzip", LOCAL_PATH+key.name])
				subprocess.call(["mv", "input",LOCAL_PATH+contestcode+"/"+problemcode+"/"])
				subprocess.call(["mv", "output",LOCAL_PATH+contestcode+"/"+problemcode+"/"])
				subprocess.call(["rm", LOCAL_PATH+key.name])
			#Uncomment the below line to delete the files from aws bucket simultaneously 	
			#bucket.delete_key(key.key)
		except:
			print(key.name+":"+"FAILED")
	#create dummy responses for users.

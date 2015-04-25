from threading import Thread
import boto
import os
import subprocess
import time

class MyThread(Thread):
 
    def __init__(self, val):
        ''' Constructor. '''
        Thread.__init__(self)
        self.val = val
 
 
    def run(self):
         for i in range(1, self.val):
             print('Value %d in thread %s' % (i, self.getName()))
 


if __name__ == '__main__':
	LOCAL_PATH = 'codechecker/'
	s3 = boto.connect_s3('access key','secretid')
	bucket = s3.get_bucket('coderunnersubmissions')
	names = {}
	for i in xrange (1000) : 
		names[i] = "string" + str(i)
	while 1:
		for key in bucket.list():
			print key.name.encode('utf-8')
			try:
				res = key.get_contents_to_filename(key.name)
				filename = key.name.encode('utf-8')
				namesplit = filename.split('#')
				username = namesplit[0]
				problemname = namesplit[1]
				contestname = namesplit[2]
				timestamp = namesplit[3]
				timelimit = namesplit[4]
				memorylimit = namesplit[5]
				newfilename = filename.replace(" ", "")
				path = contestname+"/"+problemname+"/user_codes"
				subprocess.call(["mv", filename, newfilename])
				subprocess.call(["mv", newfilename, path])
				p = subprocess.Popen("./a.out -n "+newfilename+" -m "+problemname+" -c "+contestname+" -t "+timelimit+" -f "+memorylimit,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell = True)
				output, errors = p.communicate()
				splitoutput = output.split()
				status =  splitoutput[1]
				verdict = contestname+ " " + problemname+ " " +status + " " + timestamp + "<br>"
				resp_name = username + "_response.html"
				resp = s3.get_bucket('coderunnerresponses').get_key(resp_name)
				resp.get_contents_to_filename(resp_name)
				resp.delete()
				append =  "echo '"+verdict+"' >> "+resp_name
				os.system(append)
				upload = s3.get_bucket('coderunnerresponses').new_key(resp_name)
				upload.set_contents_from_filename(resp_name)
				upload.set_acl('public-read')
		
				upload = s3.get_bucket('coderunnerusers').new_key(resp_name)
				upload.set_contents_from_filename(resp_name)
				upload.set_acl('public-read')
		
				subprocess.call(["rm",resp_name])
				bucket.delete_key(key.key)
			except:
				print (key.name+":"+"FAILED")
		time.sleep(5)

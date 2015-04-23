from threading import Thread
import boto

class MyThread(Thread):
 
    def __init__(self, val):
        ''' Constructor. '''
        Thread.__init__(self)
        self.val = val
 
 
    def run(self):
         for i in range(1, self.val):
             print('Value %d in thread %s' % (i, self.getName()))
 
             # Sleep for random time between 1 ~ 3 second
             #secondsToSleep = randint(1, 5)
             #print('%s sleeping fo %d seconds...' % (self.getName(), secondsToSleep))
             #time.sleep(secondsToSleep)
 


if __name__ == '__main__':
	LOCAL_PATH = 'codechecker/'
	s3 = boto.connect_s3('access key','secretid')
	bucket = s3.get_bucket('coderunnersubmissions')
	names = {}
	for i in xrange (1000) : 
		names[i] = "string" + str(i)
	for key in bucket.list():
		print key.name.encode('utf-8')
		try:
			res = key.get_contents_to_filename(LOCAL_PATH+key.name)
			bucket.delete_key(key.key)
			#run the file downloaded against codechecker
		except:
			print (key.name+":"+"FAILED")

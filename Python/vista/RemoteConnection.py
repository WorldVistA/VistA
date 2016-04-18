'''
Created on Sep 12, 2012

@author: jspivey
'''

class RemoteConnectionDetails(object):
    '''
    classdocs
    '''


    def __init__(self, remote_address, remote_port, username, password, default_namespace):
        '''
        Constructor
        '''
        self.remote_address = remote_address
        # self.remote_os = remote_os
        self.default_namespace = default_namespace
        self.remote_port = remote_port

        self.username = username
        self.password = password

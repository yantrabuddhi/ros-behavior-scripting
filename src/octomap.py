import rospy
import roslib
import time
from pi_face_tracker.msg import FaceEvent, Faces
from opencog.scheme_wrapper import scheme_eval, scheme_eval_h, scheme_eval_as
#import threading
from opencog.atomspace import AtomSpace, TruthValue

class OctoMap():
    def __init__(self,pub_look,pub_gaze):
        self.turn_pub=pub_look
        self.gaze_pub=pub_gaze
        self.lock=threading.Lock()
        self.sc_str_set = ""
        self.sc_str_get = ""
        self.face_array=Faces()
        #ttt=threading.Thread(target=self.thr)
        #ttt.start()
        self.atomspace = scheme_eval_as('(cog-atomspace)')#AtomSpace()#scheme_eval_as('(cog-atomspace)')
        lpth="time-map.scm"
        print "loading time-map"
        scheme_eval(self.atomspace, "(load \""+lpth+"\")")
        print "loaded time-map"

    # def thr(self):
    #     self.atomspace = AtomSpace()#scheme_eval_as('(cog-atomspace)')
    #     lpth="time-map.scm"
    #     print "loading time-map"
    #     scheme_eval(self.atomspace, "(load \""+lpth+"\")")
    #     print "loaded time-map"
    #     #print scheme_eval(self.atomspace,"(+ 2 3)")
    #     #scheme_eval(self.atomspace, "(map-ato \"faces\" (NumberNode \"2.0\") 1 2 3)")
    #     rate=rospy.Rate(30)
    #     while not rospy.is_shutdown():
    #         rate.sleep()
    #         #self.lock.acquire()
    #         try:
    #             if len(self.sc_str_set)>0:
    #                 print "faces: ", len(self.face_array)
    #                 for face in self.face_array:
    #                     #print "hello"
    #                     fac="(map-ato \"faces\" (NumberNode \""+str(face.id)+"\") "+str(face.point.x)+" "+str(face.point.y)+" "+str(face.point.z)+")"
    #                     #print "before eval ", face.id
    #                     scheme_eval(self.atomspace,fac)
    #                     #print "after eval"
    #                 self.sc_str_set=""
    #
    #             print "before look"
    #
    #             if len(self.sc_str_get)>0:
    #                 fid=self.sc_str_get
    #                 print "******look at face point: ", fid
    #                 fc="(look-at-face (NumberNode \""+fid+"\"))"
    #                 ptstr=scheme_eval(self.atomspace,fc)
    #                 if len(ptstr)<5:
    #                     print "XX Face Point Invalid XX"
    #                 else:
    #                     pts=ptstr.split()
    #                     trg = Target()
    #                     trg.x = float(pts[0])
    #                     trg.y = float(pts[1])
    #                     trg.z = float(pts[2])
    #                     self.turn_pub.publish(trg)
    #                     self.gaze_pub.publish(trg)
    #                 self.sc_str_get=""
    #         finally:
    #             #self.lock.release()
    #             pass

    def add_faces(self,faces):
        for face in self.faces:
            fac="(map-ato \"faces\" (NumberNode \""+str(face.id)+"\") "+str(face.point.x)+" "+str(face.point.y)+" "+str(face.point.z)+")"
            #scheme_eval(self.atomspace,fac)
        #self.lock.acquire()
        # try:
        #     if len(self.sc_str_set)<1:
        #         self.face_array=faces
        #         self.sc_str_set="do"
        # finally:
        #     #self.lock.release()
        #     pass


    def look_at_face(self,fid):
        print "******look at face point: ", fid
        fc="(look-at-face (NumberNode \""+str(fid)+"\"))"
        ptstr=""#scheme_eval(self.atomspace,fc)
        if len(ptstr)<5:
            print "XX Face Point Invalid XX"
        else:
            pts=ptstr.split()
            trg = Target()
            trg.x = float(pts[0])
            trg.y = float(pts[1])
            trg.z = float(pts[2])
            self.turn_pub.publish(trg)
            self.gaze_pub.publish(trg)
        #self.lock.acquire()
        #     try:
        #     if len(self.sc_str_get)<1:
        #         self.sc_str_get=str(fid)
        #         print "!!!!!!!!!! In look at face point ", fid
        # finally:
        #     #self.lock.release()
        #     pass

from flask import Flask,request, jsonify
from firebase_admin import firestore,initialize_app,credentials
import firebase_admin
import google
from flask.templating import render_template

from flask import redirect,url_for,render_template

from flask_googlemaps import GoogleMaps
from geopy.geocoders import Nominatim

import datetime
import time 
import geopy
import recog
import os
from werkzeug.utils import secure_filename
recog.preprocess()
cred=credentials.Certificate('key.json')
defaultapp=firebase_admin.initialize_app(cred)
db=firestore.client()



app=Flask(__name__)
GoogleMaps(app,key="AIzaSyBD2nuzRZuEpQtCwe0MYgDUoBHIvvCtjMU")
@app.route('/')
def home():
    return render_template('login.html')


# login page

@app.route('/login', methods=['GET', 'POST'])
def login():
    err = None
    if request.method == 'POST':
        if request.form['username'] != 'admin' or request.form['password'] != 'admin':
            err = 'Invalid Credentials. Please try again.'
        else:
            return redirect(url_for('homepage'))
            
    return render_template('login.html', error=err)

# # testing
# def login():
#     err = None
#     if request.method == 'POST':
#         x=db.collection(u'emp').document(request.form['username']).get().to_dict()
#         if   request.form['password'] != x['password']:
#             err = 'Invalid Credentials. Please try again.'
#         else:
#             return redirect(url_for('homepage'))
            
#     return render_template('login.html', error=err)


'''render main page'''

@app.route('/home')
def homepage():
    return render_template('home.html')

'''display current details'''
@app.route('/currentdetails')
def index():    
    user_refere=db.collection(u'users').stream()
    # x=db.collection(u'users').document('psr').get().to_dict()
    
    # coord=[]
    # for i in user_refere:
    #     l=(i.to_dict()['locat'].latitude,i.to_dict()['locat'].longitude)
    #     coord.append(l)
    print(type(user_refere))
    if user_refere==None:
        print('empty')
    else:
        print('not empty')
    return render_template('data.html',di=user_refere)


#showing current location of user with map
@app.route('/map/<name>')
def showmap(name):
    try:
        
        x=db.collection('users').document(name)
        a=x.get().to_dict()
        
        locator=Nominatim(user_agent='myGeoCoder')
        cor=str(a['locat'].latitude)+', '+str(a['locat'].longitude)
        
        location = locator.reverse(cor)
        
        coord=[a['locat'].latitude,a['locat'].longitude,a['date'],name,location.address]
    except Exception():
        print('erroe')

    
    return render_template('mapdisplay.html',ordinates=coord)



# @app.route('/login',methods=['POST','GET'])
# def login():

#     if request.method=='POST':
#         date_t=request.form['dt']
#         element = datetime.datetime.strptime(date_t,"%d/%m/%Y") 
#         print(type(element),'ele is ',element)
#         loc=request.form['loc']
#         loca=firebase_admin.firestore.GeoPoint(12.432223,8.123456)
        
#         print(loca)
#         print(type(loca),'locat type')
        
#         # info={
#         #     u'date' : element,
#         #     u'locat': loca
#         # }
#         # db.collection(u'fl').document(u'doc1').set(info)
#         print(type(date_t),'date is',date_t,type(loc),'loc is',loc)
#         return "<h1> %s</h1>" %date_t
#     else:
#         # user=request.args.get['nm']
#         # return redirect(url_for('success',name=user))
#         date=request.args.get['dt']
#         loc=request.args.get['loc']
#         print(type(date_t),'date is',date_t,type(loc),'loc is',loc)
#         return "<h1> %s</h1>" %date

'''render schedule'''
@app.route('/renderschedule')
def rendersch():
    return render_template('schedule.html')


@app.route('/addschedule',methods=['POST','GET'])
def addsch():
    err=None
    if request.method=='POST':
        date_t=request.form['dt']
        # element = datetime.datetime.strptime(date_t,"%d/%m/%Y") 
        # element = datetime.datetime.strptime(date_t,"%Y-%m-%d") 
        realdate=date_t[8:]+'-'+date_t[5:7]+'-'+date_t[0:4]

        # print(type(realdate),'ele is ',realdate)
        loca=request.form['loc']
        locator=Nominatim(user_agent='myGeoCoder')
        loc = locator.geocode(loca)
        us=request.form['user']
        prev=db.collection("schedules").document(us)

        if not prev.get().exists:

           return render_template('schedule.html',error="Employee doesn't exist.")
        if loc==None:
            return render_template('schedule.html',error="enter correct location.")
            # return "<h1> enter correct location</h1>"
        location=firestore.GeoPoint(loc.latitude, loc.longitude)

        # print(type(location))
        # print(type(date_t),' date ',date_t)
        sch={
            u'locdesc':loca,
            u'date' : realdate,
            u'locat':location,
            u'start' :False,
            u'end' :False,
            
        }
        prev=db.collection("schedules").document(us)
        countofdocs=prev.get().to_dict()['count']
        countofdocs+=1
        #db.collection(u'fl').document(us).collection(u'days').document(u'1').set(sch)
        db.collection("schedules").document(us).collection("list").document(realdate).set(sch)
        prev.update({u'count' :countofdocs })
        err='Schedule added successfully'
        return render_template('schedule.html',error=err)


'''adding users'''
@app.route('/addusers', methods=['GET', 'POST'])
def adding_users():
    error=None
    if request.method == 'POST':
        username=request.form['username']
        email=request.form['email']
        phoneno=request.form['pno']
        desig=request.form['designation']
        info={
            u'username' :username,
            u'email' :email,
            u'phone number':phoneno,
            u'designation' : desig
        }
        temp=request.files['file']
        sr='./known_faces/'+str(username)
        os.mkdir(sr)
        temp.save(os.path.join(sr, secure_filename(temp.filename)))
        db.collection(u'userdata').document(str(username)).set(info)
        db.collection("schedules").document(str(username)).set({
            u'count' :0,
        })
        recog.preprocess()
        error='Employee added successfully'
        # return "<h1> successfully added user</h1>"
    return render_template('addusers.html',error=error)

@app.route('/upload',methods=['GET','POST'])
def upload():
    print('entered')
    if request.method=='POST':
        
        di=dict()
        di['test']='hello'
        # di['name']='found'
        # return jsonify(di)
        # return 'found'
        if 'file' not in request.files:
            print('no file')
            return jsonify(di)
            # return "something went wrong"
        temp=request.files['file']
        
        print('processing')
        matches=recog.identify(temp)
        print('done',matches)
        # di=dict()
        if len(matches)==0:
            di['name']='not found'
            return jsonify(di)
        # di['name']=str(matches)
        return jsonify(
            name=str(matches[0])
        )
        # return 'found'


@app.route('/showpage',methods=['GET','POST'])
def showpage():
    return render_template('uploading.html')

if __name__=='__main__':
    app.run(host='192.168.0.159',port=5000)
    # app.run(debug=True,use_reloader=True)






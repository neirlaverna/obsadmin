importScripts('https://www.gstatic.com/firebasejs/8.2.9/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.2.9/firebase-messaging.js');

firebase.initializeApp({
    apiKey: 'AIzaSyDLiI9AuviVaKSEqe-trYv_z5G9Z36Uzt4',
    appId: '1:272606286201:web:fef7bee851e988897e5fa8',
    messagingSenderId: '272606286201',
    projectId: 'obsmngmnt',
    authDomain: 'obsmngmnt.firebaseapp.com',
    storageBucket: 'obsmngmnt.appspot.com',
    measurementId: 'G-5HJ7ZNCZ4S',
    databaseURL : 'https://obsmngmnt-default-rtdb.asia-southeast1.firebasedatabase.app'
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
  const notification = JSON.parse(payload.data.notification);
  const notificationTitle = notification.title;
  const notificationOptions = {
    body: notification.body,
    icon: notification.icon,
  };

  return self.registration.showNotification(
    notificationTitle,
    notificationOptions
  );
});

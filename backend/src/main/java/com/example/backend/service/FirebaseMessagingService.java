package com.example.backend.service;

import com.example.backend.request.PushNotificationRequest;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FirebaseMessagingService {

    @Autowired
    FirebaseMessaging firebaseMessaging;


    public String sendNotification(PushNotificationRequest request) throws FirebaseMessagingException {
        Notification notification = Notification
                .builder()
                .setTitle(request.getTitle())
                .setBody(request.getBody())
                .build();

        Message message = Message
                .builder()
                .setToken(request.getToken())
                .setNotification(notification)
                .putAllData(request.getData())
                .build();

        return firebaseMessaging.send(message);
    }

}

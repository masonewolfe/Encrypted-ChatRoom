package com.example.selfdestructim;
import androidx.appcompat.app.AppCompatActivity;

import android.accounts.AccountManager;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import org.jivesoftware.smack.AbstractXMPPConnection;
import org.jivesoftware.smack.ConnectionConfiguration;
import org.jivesoftware.smack.SmackException;
import org.jivesoftware.smack.StanzaListener;
import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.android.AndroidSmackInitializer;
import org.jivesoftware.smack.chat.ChatManagerListener;
import org.jivesoftware.smack.chat.ChatMessageListener;
import org.jivesoftware.smack.chat2.Chat;
import org.jivesoftware.smack.chat2.ChatManager;
import org.jivesoftware.smack.chat2.IncomingChatMessageListener;
import org.jivesoftware.smack.packet.Message;
import org.jivesoftware.smack.packet.Presence;
import org.jivesoftware.smack.packet.Stanza;
import org.jivesoftware.smack.tcp.XMPPTCPConnection;
import org.jivesoftware.smack.tcp.XMPPTCPConnectionConfiguration;
import org.jxmpp.jid.DomainBareJid;
import org.jxmpp.jid.EntityBareJid;
import org.jxmpp.jid.impl.JidCreate;
import org.jxmpp.stringprep.XmppStringprepException;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import javax.net.ssl.HostnameVerifier;

public class MainActivity extends AppCompatActivity
{
    private Button beginButton;
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        Button startApp;
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        startApp = (Button) findViewById(R.id.startApp);
        startApp.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                new Thread() {
                    @Override
                    public void run() {
                    // Create a connection to the jabber.org server on a specific port.
                        try {

                            InetAddress addr = null;
                            try {

                                // inter your ip4address now checking it
                                addr = InetAddress.getByName("52.188.65.46");
                            } catch (UnknownHostException e)
                            {
                                e.printStackTrace();
                            }
                            HostnameVerifier verifier = (hostname, session) -> false;
                            DomainBareJid serviceName = null;
                            try {
                                serviceName = JidCreate.domainBareFrom("selfdestructim.com");
                            } catch (XmppStringprepException e) {
                                e.printStackTrace();
                            }
                            XMPPTCPConnectionConfiguration config = XMPPTCPConnectionConfiguration.builder()
                                    .setUsernameAndPassword("mason","Wolfez123!@#")
                                    .setPort(5222)
                                    .setSecurityMode(ConnectionConfiguration.SecurityMode.disabled)
                                    .setXmppDomain(serviceName)
                                    .setHostnameVerifier(verifier)
                                    .setHostAddress(addr)
                                    .build();
                            AbstractXMPPConnection conn2 = new XMPPTCPConnection(config);
                            conn2.connect();
                            conn2.login();
                            ChatManager chatManager = ChatManager.getInstanceFor(conn2);
                            EntityBareJid jid = JidCreate.entityBareFrom("jordan@selfdestructim.com");
                            Chat chat = chatManager.chatWith(jid);
                            chat.send("YO JORDAN THIS IS A TEST");
                            conn2.disconnect();
                        } catch (XMPPException e) {
                            throw new RuntimeException(e);
                        } catch (SmackException e) {
                            throw new RuntimeException(e);
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        } catch (InterruptedException e) {
                            throw new RuntimeException(e);
                        }

                    }
                }.start();


            }
        });
    }
}

package com.servlet;

import java.io.IOException;
import java.util.Date;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/clock")
public class socketServlet {

	Thread thread;
	boolean running = false;

	@OnOpen
	public void startClock(Session session) {
		final Session mySession = session;
		this.running = true;
		this.thread = new Thread(() -> {
			while (running) {
				Date date = new Date();
				try {
					mySession.getBasicRemote().sendText(String.valueOf(date.getTime()));
					Thread.sleep(1000);
				} catch (IOException | InterruptedException e) {
					e.printStackTrace();
					running = false;
				}
			}
		});
		
		this.thread.start();
	}

	@OnClose
	public void stopClock() {
		this.running = false;
		this.thread = null;
	}

	@OnError
	public void clockError(Throwable t) {
		this.stopClock();
	}

}

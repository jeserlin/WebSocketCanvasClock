<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="https://code.jquery.com/jquery-1.9.1.js"></script>
	<title>WebSocket Canvas Clock</title>
	<script type="text/javascript">
		var websocket;
		var last_time;

		$(function() {
			var canvas = document.getElementById("canvas");
			var ctx = canvas.getContext("2d");
			var radius = canvas.height / 2;
			init();

			//initialize websocket
			function init() {
				//canvas
				ctx.translate(radius, radius);
				radius = radius * 0.90;
				
				var wsUri = "ws://localhost:8080/WebSocketCanvasClock/clock";
				websocket = new WebSocket(wsUri);

				websocket.onmessage = function (evt) {
					last_time = evt.data;
					$('#clock').html(new Date(Number(last_time)));
					drawClock();
				};

				websocket.onerror = function (evt) {
					$('#clock').html("websocket error");
					websocket.close();
				};
			}

			function drawClock() {
				drawFace(ctx, radius);
				drawNumbers(ctx, radius);
				drawTime(ctx, radius);
			}

			function drawFace(ctx, radius) {
				var grad;
				ctx.beginPath();
				ctx.arc(0, 0, radius, 0, 2*Math.PI);
				ctx.fillStyle = 'white';
				ctx.fill();
				grad = ctx.createRadialGradient(0,0,radius*0.95, 0,0,radius*1.05);
				grad.addColorStop(0, '#AD5D5D');
				grad.addColorStop(0.5, '#eca1a6');
				grad.addColorStop(1, '#AD5D5D');
				ctx.strokeStyle = grad;
				ctx.lineWidth = radius*0.1;
				ctx.stroke();
				ctx.beginPath();
				ctx.fillStyle = '#ada397';
				ctx.fill();
			}
			function drawNumbers(ctx, radius) {
				var ang;
				var num;
				ctx.font = radius*0.15 + "px arial";
				ctx.textBaseline = "middle";
				ctx.textAlign = "center";
				for(num = 1; num <= 12; num++) {
					ang = num * Math.PI / 6;
					ctx.rotate(ang);
					ctx.translate(0, -radius*0.85);
					ctx.rotate(-ang);
					ctx.fillText(num.toString(), 0, 0);
					ctx.rotate(ang);
					ctx.translate(0, radius*0.85);
					ctx.rotate(-ang);
				}
			}

			function drawTime(ctx, radius){
				var now = new Date(Number(last_time));
				var hour = now.getHours();
				var minute = now.getMinutes();
				var second = now.getSeconds();
				//hour
				hour=hour%12;
				hour=(hour*Math.PI/6)+
				(minute*Math.PI/(6*60))+
				(second*Math.PI/(360*60));
				drawHand(ctx, hour, radius*0.55, radius*0.07);
				//minute
				minute = (minute * Math.PI / 30) + (second * Math.PI / (30 * 60));
				drawHand(ctx, minute, radius*0.75, radius*0.07);
				// second
				second=(second*Math.PI/30);
				drawHand(ctx, second, radius*0.9, radius*0.02);
				//rabbit image in the middle
				var img = new Image;
				img.src = 'image/yuan.png';
				ctx.drawImage(img,-40,-40,80,80);
			}

			function drawHand(ctx, pos, length, width) {
				ctx.beginPath();
				ctx.lineWidth = width;
				ctx.lineCap = "arrow";
				ctx.moveTo(0,0);
				ctx.rotate(pos);
				ctx.lineTo(0, -length);
				ctx.stroke();
				ctx.font = "30px Arial";
				ctx.fillText(" ",10,50);
				ctx.rotate(-pos);
			}
		})
		
		
</script>
 </head>
	<body>
		<h3>This is a canvas clock with server time.(from WebSocket)</h3>
		<div id="clock"></div>
		<canvas id="canvas" width="400" height="400" style="background-color:#fff"></canvas>
	</body>
</html>  
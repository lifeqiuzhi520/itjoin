<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=path%>/resources/css/style.css" type="text/css" />
<link rel="stylesheet"  href="<%=path %>/resources/flowplayer/skin/functional.css" />
<script type="text/javascript" src="<%=path%>/resources/js/jquery.min.js"></script>
  <script  src="<%=path %>/resources/flowplayer/flowplayer.min.js" ></script>
  <script type="text/javascript">
window.onload = function () {
	  var feature = {
	        cuepoints: [4],
	        title: "feature",
	        sources: [
/*   { type: "video/webm",  src: "//stream.flowplayer.org/bauhaus.webm"}, */
	          { type: "video/mp4",   src: "/resources/video/1.mp4" },
	          { type: "video/flash", src: "mp4:bauhaus" }
	        ]
	      },
	      midroll = {
	        cuepoints: [5],
	        title: "mid-roll",
	        sources: [
	    /*       { type: "video/webm",  src: "//stream.flowplayer.org/functional.webm"}, */
	          { type: "video/mp4",   src: "/resources/video/1.mp4" },
	          { type: "video/flash", src: "mp4:functional" }
	        ]
	      },
	      container = document.getElementById("player"),
	    //  info = document.getElementById("info"),
	 
	      // helper to show/hide UI Elements of this player
	      // getElementsByClassName is not supported in IE8
	      toggleUiElement = function (klass, show) {
	        var divs = container.getElementsByTagName("div"),
	            klasspat = new RegExp('(^| )' + klass + '( |$)'),
	            i;
	 
	        for (i = 0; i < divs.length; i += 1) {
	          if (klasspat.test(divs[i].className)) {
	            divs[i].style.display = show ? "block" : "none";
	            return;
	          }
	        }
	      };
	 

	  flowplayer(container, {
	    ratio: 5/12,
	  //  rtmp: "rtmp://s3b78u0kbtx79q.cloudfront.net/cfx/st",
	    clip: feature
	 
	  }).on("cuepoint", function (e, api, cuepoint) {
	    if (cuepoint.time === feature.cuepoints[0]) {
	      toggleUiElement("fp-controls");
	      toggleUiElement("fp-time");
	     // info.innerHTML = "playing 5 second midroll at " + cuepoint.time + " seconds";
	 
	      api.load(midroll, function (e, api) {
	        api.disable(true);
	      });
	 
	    } else if (cuepoint.time === midroll.cuepoints[0]) {
	      api.disable(false).load(feature, function (e, api) {
	        api.seek(feature.cuepoints[0] + 0.2);
	 
	        toggleUiElement("fp-controls", true);
	        toggleUiElement("fp-time", true);
	   //     info.innerHTML = "feature resumed at " + (feature.cuepoints[0] + 0.2) + " seconds";
	      });
	 
	    }
	  });
	 
	};
</script>
</head>
<body>
 	<div class=" C_content">
		<div class=" C_layout C_sp" style="overflow: hidden;">
			<h2>${video.name }</h2>
			<div class="C_sp_nr">
				<div id="videoSrcId " class="videoDiv">
					<div id="player" class="fixed-controls  videoDiv"  style="width: 700px; height: 400px;"></div>
				</div>
				<div class="C_sp_nr2 videoDiv">
					<div class="C_sp_nr2a">
						<ul>
								<li><a
									href=".."> <img
										src="../image/show?fileName=" />
										<p>
											<span>集：</span>
										</p>
								</a></li>
						</ul>
					</div>
					<div class="C_bq">
						<dl>
							<dd class="C_tab1">
								<i class="glyphicon glyphicon-menu-up"></i>
							</dd>
							<dd class="C_tab2">
								<i class="glyphicon glyphicon-menu-down"></i>
							</dd>
						</dl>
					</div>
				</div>
			</div>
			<div class="C_ly">
				<div class="C_ly_l">
					<div class="C_lyq">
						<textarea id="comment"></textarea>
						<button onclick="submitComment('')">提交评论</button>
					</div>
					<div class="C_lyq_nr">
						<h2>全部评论</h2>
					</div>
				</div>
				<div class="C_ly_r">
					<img src="../resources/images/C_gbg.jpg" />
				</div>
			</div>
		</div>
	</div>
	<div id="imgBox" style="display: none">
		<img src="../resources/images/loading.gif" alt="" />
	</div>
</body>
</html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf"%>
<%@ page session="false"%>

<!DOCTYPE html>
<html ng-app="elicit">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width" />
<link rel="shortcut icon" href="<c:url value="/bower_components/mcda-web/app/img/favicon.ico" />" type="image/x-icon" />

<title>mcda.drugis.org</title>

  <link rel="stylesheet" type="text/css" href="bower_components/font-awesome/css/font-awesome.min.css">
  <link rel="stylesheet" type="text/css" href="bower_components/nprogress/nprogress.css">
  <link rel="stylesheet" type="text/css" href="bower_components/jslider/dist/jquery.slider.min.css">
  <link rel="stylesheet" type="text/css" href="bower_components/nvd3/src/nv.d3.css">

  <link rel="stylesheet" type="text/css" href="<c:url value="/bower_components/mcda-web/app/css/mcda-drugis.css" />">

  <script src="bower_components/requirejs/require.js" data-main="app/js/main.js"></script>

</head>

<body>
  <form method="POST" action="<c:url value="/signout" />" id="signout_form">
    <input type="hidden" name="_csrf" value="<c:out value="${_csrf.token}" />" />
  </form>
  
  <nav class="top-bar" data-topbar>
    <ul class="title-area">
      <li class="name">
        <h1>
          <a href="#">mcda.drugis.org</a>
        </h1>
      </li>
    </ul>

    <section class="top-bar-section">
      <!-- Right Nav Section -->
      <ul class="right">
        <li class="has-dropdown"><a href="#"><i class="fa fa-user fa-fw"></i> <c:out value="${account.firstName} ${account.lastName} " /></a>
          <ul class="dropdown">
            <li>
              <a href="#" onClick="signout()">Sign out</a>
            </li>
          </ul></li>
      </ul>
    </section>
  </nav>
  <section>
    <div class="color-stripe"></div>
  </section>


  <div class="row">
    <div class="columns">
      <alert type="info">
        <strong>Disclaimer:</strong> this is <em>beta</em> software. We store your workspaces on our servers. While we try our best to keep them secure and compatible with future versions, we can make no guarantees.
      </alert>
    </div>
  </div>
    
  <div ui-view></div>


  <script>
	window.patavi = { "WS_URI": "wss://patavi.drugis.org/ws" };
    window.config = {
      examplesRepository : "examples/",
      workspacesRepository : {
        service : "RemoteWorkspaces",
        url : "/workspaces/",
        _csrf_token : "${_csrf.token}",
        _csrf_header : "${_csrf.headerName}"
      }
    };
   
    function signout(){
      var signoutForm = document.getElementById('signout_form');
      
      if(signoutForm){
        signoutForm.submit();
      }
    }
  </script>
<div class="push"></div>

</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" %><% response.sendRedirect(request.getContextPath()+"/catalogue"+(request.getQueryString()==null?"":"?"+request.getQueryString())); %>

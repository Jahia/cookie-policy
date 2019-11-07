<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="css" resources="cookie.css,cookiecuttr.css"/>
<template:addResources type="javascript" resources="js.cookie.js,jquery.cookiecuttr.js"/>

<c:set var="cookieModalMessage" value="${currentNode.properties['cookie_policy:cookieModalMessage'].string}"/>
<c:set var="cookieMessage" value="${currentNode.properties['cookie_policy:cookieMessage'].string}"/>
<c:set var="cookieWhatAreLinkText" value="${currentNode.properties['cookie_policy:cookieWhatAreLinkText'].string}"/>
<c:set var="cookieOverlayEnabled" value="${currentNode.properties['cookie_policy:cookieOverlayEnabled'].string}"/>
<c:set var="cookieDomain" value="${currentNode.properties['cookie_policy:cookieDomain'].string}"/>
<c:set var="cookieExpires" value="${currentNode.properties['cookie_policy:cookieExpires'].string}"/>
<c:set var="cookieAcceptButtonText" value="${currentNode.properties['cookie_policy:cookieAcceptButtonText'].string}"/>

<template:addResources type="inline">
    <script>
        $(document).ready(function () {
            $.cookieCuttr({
                <c:if test="${! empty cookieExpires}">
                    cookieExpires: ${cookieExpires}
                </c:if>
                <c:if test="${! empty cookieOverlayEnabled and empty param['policycookie']}">
                , cookieOverlayEnabled: ${cookieOverlayEnabled}
                </c:if>
                <c:if test="${! empty cookieMessage}">
                , cookieAnalyticsMessage: '${fn:escapeXml(cookieMessage)}'
                </c:if>
                <c:if test="${! empty cookieAcceptButtonText}">
                    , cookieAcceptButtonText: '${fn:escapeXml(cookieAcceptButtonText)}'
                </c:if>
                <c:if test="${! empty cookieWhatAreLinkText}">
                    , cookieWhatAreLinkText: '${fn:escapeXml(cookieWhatAreLinkText)}'
                </c:if>
                <c:if test="${! empty cookieDomain}">
                , cookieDomain: '${fn:escapeXml(cookieDomain)}'
                </c:if>
                <c:if test="${jcr:isNodeType(currentNode, 'cookie_policy_mix:cookiePolicyExternalLink')}">
                    <c:url var="cookieWhatAreTheyLink" value="${currentNode.properties['cookie_policy:cookiePageExternalLink'].string}" />
                    <c:if test="${! empty cookieWhatAreTheyLink}">
                    ,cookieWhatAreTheyLink: '${fn:escapeXml(cookieWhatAreTheyLink)}'
                    </c:if>
                </c:if>
                <c:if test="${jcr:isNodeType(currentNode, 'cookie_policy_mix:cookiePolicyLink')}">
                    <c:url var="cookieWhatAreTheyLink" value="${currentNode.properties['cookie_policy:cookiePageLink'].node.url}" context="/"/>
                    <c:if test="${! empty cookieWhatAreTheyLink}">
                        , cookieWhatAreTheyLink: '${fn:escapeXml(cookieWhatAreTheyLink)}?policycookie=true'
                    </c:if>
                </c:if>
                <c:if test="${jcr:isNodeType(currentNode, 'cookie_policy_mix:cookiePolicyModalMessage')}">
                    , cookieModal: true
                </c:if>
                , cookieSite: "${currentNode.resolveSite.name}"
                , cookieEffectiveDate: "<fmt:formatDate value="${currentNode.properties['cookie_policy:cookieEffectiveDate'].time}" pattern="yyyy-MM-dd HH:mm:ss"/>"
            });
        });
    </script>
</template:addResources>
<%@ page import="com.alkacon.opencms.v8.comments.*,org.opencms.jsp.util.*,org.opencms.main.*, java.util.Map"%>
<%@ taglib
	prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib
	prefix="cms" uri="http://www.opencms.org/taglib/cms"%><%@ taglib
	prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<cms:formatter var="content">
<div>
	<fmt:setLocale value="${cms.workplaceLocale}" />
	<cms:bundle basename="com.alkacon.opencms.v8.comments.workplace">
	<c:set var="notVisibleMessage">
		<c:choose>
			<c:when test="${empty content.value.ConfigUri.stringValue}"><fmt:message key="warning.no_config" /></c:when>
			<c:when test="${cms.edited}">
				<fmt:message key="warning.being_edited" />
				<c:choose>
					<c:when test="${cms.element.settings.visibility=='directview'}">
						<br />
						<fmt:message key="warning.direct_view_only" />
					</c:when>
					<c:when	test="${cms.element.settings.visibility=='detailview'}">
						<br />
						<fmt:message key="warning.detail_view_only" />
					</c:when>
				</c:choose>
			</c:when>
			<c:when	test="${cms.detailRequest && cms.element.settings.visibility=='directview'}">
				<fmt:message key="warning.direct_view_only" />
			</c:when>
			<c:when	test="${not cms.detailRequest && cms.element.settings.visibility=='detailview'}">
				<fmt:message key="warning.detail_view_only" />
			</c:when>
		</c:choose>
	</c:set>
	</cms:bundle>
	<c:choose>
		<c:when test="${not empty notVisibleMessage}">
			<c:if test="${not cms.isOnlineProject}">
				<div style="border: 1px solid red;">
					<c:if test="${not empty content.value.Title.stringValue}"><h3>${content.value.Title.stringValue}</h3></c:if>
					<p>${notVisibleMessage}</p>
				</div>
			</c:if>
		</c:when>
		<c:otherwise>
			<c:set var="configUri" value="${content.value.ConfigUri.stringValue}" />
			<c:set var="cmturi" scope="request">
				<c:choose>
					<c:when test="${cms.detailRequest}">${cms.detailContentSitePath}</c:when>
					<c:otherwise>${cms.requestContext.uri}</c:otherwise>
				</c:choose>
			</c:set>
			<c:set var="formid">
				<c:if test="${!content.value.FormId.isEmptyOrWhitespaceOnly}">${content.value.FormId}</c:if>
			</c:set><%
				Map<String, String> dynamicConfig = CmsCommentsAccess.generateDynamicConfig(pageContext.getAttribute("formid").toString());
			    CmsCommentsAccess alkaconCmt = new CmsCommentsAccess(
											pageContext, request, response,
											(String) pageContext.getAttribute("configUri"), dynamicConfig);
									pageContext.setAttribute("alkaconCmt", alkaconCmt);
			%>	
				<c:if test="${alkaconCmt.userCanView || alkaconCmt.userCanManage || alkaconCmt.userCanPost || alkaconCmt.offerLogin}"> <%-- Do not show anything if no possibility to view comments --%>
					<fmt:setLocale value="${cms.locale}"/>
					<c:set var="bundle">${alkaconCmt.resourceBundle}</c:set>
					<cms:bundle basename="${bundle}">
						<c:set var="formid">${alkaconCmt.config.formId}</c:set>
						<c:set var="minimized"><cms:elementsetting name="minimized" default="${content.hasValue.Minimized ? content.value.Minimized.stringValue : ''}"/></c:set>
						<c:set var="list"><cms:elementsetting name="list" default="${content.hasValue.List ? content.value.List.stringValue : ''}"/></c:set>
						<c:set var="security"><cms:elementsetting name="security" default="${content.hasValue.Security ? content.value.Security.stringValue : ''}"/></c:set>
						<c:set var="allowreplies"><cms:elementsetting name="allowreplies" default="${content.hasValue.AllowReplies ? content.value.AllowReplies : alkaconCmt.config.allowReplies}"/></c:set>
						<c:set var="url">
							<cms:link>
								<c:choose>
								<c:when test="${!minimized == 'false' && (minimized == 'true' || (content.hasValue.Minimized && content.value.Minimized.stringValue=='true') || not alkaconCmt.maximized)}">
									%(link.weak:/system/modules/com.alkacon.opencms.v8.comments/elements/comment_header.jsp:56328ff3-15df-11e1-aeb4-9b778fa0dc42)
								</c:when>
								<c:otherwise>
									%(link.weak:/system/modules/com.alkacon.opencms.v8.comments/elements/comment_list.jsp:5639bbed-15df-11e1-aeb4-9b778fa0dc42)
								</c:otherwise>
								</c:choose>
							</cms:link>
						</c:set>
						<c:set var="stylesheet">
							<c:choose>
								<c:when test="${!empty alkaconCmt.config.styleSheet}" >
									<cms:link>${alkaconCmt.config.styleSheet}</cms:link>
								</c:when>
								<c:otherwise>
									<cms:link>%(link.weak:/system/modules/com.alkacon.opencms.v8.comments/resources/comments.bootstrap.css:60ba85cb-d4e6-11e3-b321-6306da683c37)</cms:link>
								</c:otherwise>
							</c:choose>
						</c:set>
						<c:set var="data">
							{       "cmturi" :"${alkaconCmt.uri}", 
									"configUri" : "${configUri}", 
									"currenturi" : "${cms.requestContext.currentUri}",
									"cmtminimized" : "${minimized}",
									"cmtlist" :"${list}",
									"cmtsecurity" :"${security}",
									"cmtformid" : "${formid}",
									"cmtallowreplies" : "${allowreplies}",
									"__locale" : "${cms.locale}",
									"cmtcolor" : "${cms.element.settings.color}",
									"cmtpage"  : "0"
							 }
						</c:set>
						<c:set var="linkInnerList"><cms:link>%(link.weak:/system/modules/com.alkacon.opencms.v8.comments/elements/comment_innerlist.jsp:5634d9e8-15df-11e1-aeb4-9b778fa0dc42)</cms:link></c:set>
						<c:set var="linkList"><cms:link>%(link.weak:/system/modules/com.alkacon.opencms.v8.comments/elements/comment_list.jsp:5639bbed-15df-11e1-aeb4-9b778fa0dc42)</cms:link></c:set>
						<c:set var="linkReplies"><cms:link>%(link.weak:/system/modules/com.alkacon.opencms.v8.comments/elements/comment_replies.jsp:6623c30f-c489-11e3-9343-6306da683c37)</cms:link></c:set>
						<c:set var="linkActions"><cms:link>%(link.weak:/system/modules/com.alkacon.opencms.v8.comments/elements/comment_actions.jsp:5626a908-15df-11e1-aeb4-9b778fa0dc42)</cms:link></c:set>
						<c:set var="linkPage"><cms:link>%(link.weak:/system/modules/com.alkacon.opencms.v8.comments/elements/comment_page.jsp:5647ecd1-15df-11e1-aeb4-9b778fa0dc42)</cms:link></c:set>
						<c:set var="linkLogin"><cms:link>%(link.weak:/system/modules/com.alkacon.opencms.v8.comments/elements/comment_login.jsp:563c05e2-15df-11e1-aeb4-9b778fa0dc42)</cms:link></c:set>
						<c:set var="linkForm"><cms:link>%(link.weak:/system/modules/com.alkacon.opencms.v8.comments/elements/comment_form.jsp:562b63fd-15df-11e1-aeb4-9b778fa0dc42)</cms:link></c:set>
					</cms:bundle>
					<div>
						<c:set var="defaultTitle"><fmt:message key="titel.view.comments" /></c:set>
						<c:set var="title">${content.hasValue.Headline ? content.value.Headline.stringValue : defaultTitle}</c:set>
						<% CmsCommentStringTemplateHandler templateHandler = new CmsCommentStringTemplateHandler(alkaconCmt);
						   String templateHtml = templateHandler.buildHeadlineHtml((String)pageContext.getAttribute("title"));
						   pageContext.setAttribute("headlineHtml", templateHtml);
						%>
						${headlineHtml}
						<div id="commentbox" 
							 class="commentbox cmtLoading" 
							 cmt-link-innerlist='${linkInnerList}' 
							 cmt-link-list='${linkList}' 
							 cmt-link-page='${linkPage}' 
							 cmt-link-replies='${linkReplies}' 
							 cmt-link-actions='${linkActions}' 
							 cmt-link-login='${linkLogin}'
							 cmt-link-form='${linkForm}'
							 cmt-param-data='${data}' 
							 cmt-url='${url}' 
							 cmt-stylesheet='${stylesheet}' 
							 cmt-resourcebundle='${alkaconCmt.resourceBundle}'>
						</div>
					</div>
				</c:if>
			</c:otherwise>
		</c:choose>
	</div>
</cms:formatter>
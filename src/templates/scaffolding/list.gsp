<% import grails.persistence.Event %>
<%=packageName%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="\${message(code: '${domainClass.propertyName}.label', default: '${className}')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
		<parameter name="menu_${className}" value="active" />
	</head>
	<body>
		<div class="page-header">
			<h1><i class="icon-briefcase"></i>\${entityName} management <small><g:message code="default.list.label" args="[entityName]" /></small></h1>
		</div>
		<div class="row rowbar">
			<div class="span6">
				<div id="search_bar" class="rowbar-left pull-left">
					<g:form action="list" class="form-inline" method="GET">
						<div class="input-append">
						<g:textField name="q" placeholder="Text to search" value="\${params.q}" elementId="appendedInputButton" class="span3" />
						<button class="btn" type="button">Search</button>
						</div>
					</g:form>
				</div>
			</div>
			<div class="span6">
				<div id="options_bar" class="rowbar-right pull-right">
					<g:link class="btn btn-success" action="create">
						<i class="icon-plus icon-white"></i>
						<g:message code="default.create.label" args="[entityName]" />
					</g:link>
				</div>
			</div>
		</div>
		<g:if test="\${${propertyName}List}">
		<table class="table table-striped table-condensed">
			<thead>
				<tr>
				<%  excludedProps = Event.allEvents.toList() << 'id' << 'version'
					allowedNames = domainClass.persistentProperties*.name << 'dateCreated' << 'lastUpdated'
					props = domainClass.properties.findAll { allowedNames.contains(it.name) && !excludedProps.contains(it.name) && it.type != null && !Collection.isAssignableFrom(it.type) }
					Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
					props.eachWithIndex { p, i ->
						if (i < 6) {
							if (p.isAssociation()) { %>
					<th><g:message code="${domainClass.propertyName}.${p.name}.label" default="${p.naturalName}" /></th>
				<%      } else { %>
					<g:sortableColumn property="${p.name}" title="\${message(code: '${domainClass.propertyName}.${p.name}.label', default: '${p.naturalName}')}" />
				<%  }   }   } %>
					<th class="span2"></th>
				</tr>
			</thead>
			<tbody>
			<g:each in="\${${propertyName}List}" status="i" var="${propertyName}">
				<tr class="\${(i % 2) == 0 ? 'even' : 'odd'}">
				<%  props.eachWithIndex { p, i ->
						if (i == 0) { %>
					<td><g:link action="show" id="\${${propertyName}.id}">\${fieldValue(bean: ${propertyName}, field: "${p.name}")}</g:link></td>
				<%      } else if (i < 6) {
							if (p.type == Boolean || p.type == boolean) { %>
					<td><g:formatBoolean boolean="\${${propertyName}.${p.name}}" /></td>
				<%          } else if (p.type == Date || p.type == java.sql.Date || p.type == java.sql.Time || p.type == Calendar) { %>
					<td><g:formatDate date="\${${propertyName}.${p.name}}" /></td>
				<%          } else { %>
					<td>\${fieldValue(bean: ${propertyName}, field: "${p.name}")}</td>
				<%  }   }   } %>
					<td>
						<div class="list-actions pull-right">
							<g:link class="btn btn-mini" action="show" id="\${${propertyName}?.id}" title="\${message(code: 'default.button.show.label', default: 'Show')}" rel="tooltip">
								<i class="icon-search"></i>
							</g:link>
							<g:link class="btn btn-mini" action="edit" id="\${${propertyName}?.id}" title="\${message(code: 'default.button.edit.label', default: 'Edit')}" rel="tooltip">
								<i class="icon-pencil"></i>
							</g:link>
							<g:form action="delete">
								<g:hiddenField name="id" value="\${${propertyName}?.id}" />								
								<button class="btn btn-mini" type="submit" name="_action_delete" onclick="return confirm('\${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" title="\${message(code: 'default.button.delete.label', default: 'Delete')}"  rel="tooltip">
									<i class="icon-trash"></i>
								</button>
							</g:form>
						</div>
					</td>
				</tr>
			</g:each>
			</tbody>
            <tfooter>
                <tr>
                    <td colspan="100%">
                        <div class="pull-right">
                        <strong>Showing \${${propertyName}List?.size()} of \${${propertyName}Total}</strong>
                        </div>
                    </td>
                </tr>
            </tfooter>
		</table>
		<div class="row">
			<div class="span12">
				<div class="pagination pagination-centered">
					<g:paginate total="\${${propertyName}Total}" maxsteps="4" params="['q':params?.q]" />
				</div>
			</div>
		</div>
		</g:if>
		<g:else>
			<g:render template="/common/empty" />
		</g:else>
	</body>
</html>

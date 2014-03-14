## -*- coding: utf-8 -*-
##
## these methods control the page background (css file), the name of the page, any links in that name, etc...
##
<%namespace name="util" file="/shared/utils/misc_utils.mako"/>

## css include controls the page look
<%def name="stop_css()"><link rel="stylesheet" href="${util.url_domain()}/css/triptools/triptools-ss.css" type="text/css" media="all" /></%def>
<%def name="tripplanner_css()"><link rel="stylesheet" href="${util.url_domain()}/css/triptools/triptools-tp.css" type="text/css" media="all"/></%def>

<%def name="h1_base_stop_stations(name, extra_params, base_params)">
    <div id="triptool" class="stopsstations-icon">
        <a href="stop_select_form.html?${base_params}${extra_params}">${_(u'Stops & Stations')}</a>
</%def>
#
# for stop & station pages that only show the basic header (no specific stop info / alerts / etc...)
#
<%def name="stop_select(name='', extra_params='', base_params='me')">
    ${h1_base_stop_stations(name, extra_params, base_params)}
    </div>
    <h1>${name}</h1>
</%def>

#
# for stop & station pages that have specific stop info (ala alerts / stop landing page link / etc...)
#
<%def name="stop(name='', extra_params='', base_params='me', stop=None, has_alerts=False)">
    ${h1_base_stop_stations(name, extra_params, base_params)}
    </div>
    <h1>${_(u'Schedule for')}<!--TODO only show this for stop_schedule.html -->
        ${name}
        %if has_alerts:
        ${util.alerts_inline_icon_link()}
        %endif
    </h1>
</%def>

<%def name="trip_form_link(name, extra_params, base_params)">
<div id="triptool" class="tripplanner-icon">
    <a href="planner_form.html?${base_params}${extra_params}">${_(u'Trip Planner')}</a>
</div>
</%def>

<%def name="trip_planner(name='', extra_params='', base_params='me')">
${trip_form_link(name, extra_params, base_params)}
<h1>
    ${name}
</h1>
</%def>

<%def name="trip_planner_form(name='', extra_params='', base_params='me')">
${trip_form_link(name, extra_params, base_params)}
<!--
<h2 class="top">
    ${name}
</h2>
-->
</%def>


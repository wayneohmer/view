## -*- coding: utf-8 -*-
##
## routines for stop / stop_schedule pages
##
<%namespace name="util" file="/shared/utils/misc_utils.mako"/>
<%namespace name="page" file="/shared/utils/pagetype_utils.mako"/>
<%namespace name="form" file="/shared/utils/form_utils.mako"/>
<%namespace name="rs"   file="/shared/utils/route_select_utils.mako"/>

<!-- TODO allow desktop to have "TriMet: " in front of page title -->
<%def name="page_title(stop)">${_(u'Stop ID')} ${stop['stop_id']} - ${stop['name']}</%def>
<%def name="str_title(stop)"><% return "Stop ID {0}".format(stop['stop_id']) %></%def>

##
## stop select form
##
<%def name="stop_select_form(geo_place='', geo_type='place', form_action='stops_near.html', is_mobile=False)">
<div id="findstop">
    <form action="${form_action}" method="GET" name="geocode" class="triptools-form">
        ${form.has_geocode_hidden('false')}
        ${form.get_extra_params_hidden_inputs()}
        ${form.search_input(_(u'Find stops and stations near'), geo_place, is_mobile=is_mobile)}
        ${form.search_submit(_(u'Find stops'))}
    </form>
    ${util.or_bar()}
    ${rs.route_select_form('stop_select_list.html', routes['routes'], "_gaq.push(['_trackEvent', 'StopsStations', 'Submit', 'MainForm Select-a-line submit']);")}
</div>
</%def>


##
## stop ambiguous geocode form(s) 
##
<%def name="geocode_form(geocoder_results, geo_place='', geo_type='place', form_action='stops_near.html', is_mobile=False)">
<div id="location">
    %if geocoder_results and len(geocoder_results) > 0:
    <form action="${form_action}"  method="GET" name="ambig-list" class="triptools-form">
        ${form.has_geocode_hidden('true')}
        ${form.get_extra_params_hidden_inputs()}
        ${form.search_list(_(u'Select a location'), geocoder_results)}
    </form>
    ${util.or_bar()}
    %endif

    <form action="${form_action}"  method="GET" name="geocode" class="triptools-form">
        ${form.has_geocode_hidden('false')}
        ${form.get_extra_params_hidden_inputs()}
        ${form.search_input(_(u'Find stops and stations near'), place=geo_place, clear_form=False, is_mobile=is_mobile)}
        ${form.search_submit(_(u'Continue'))}
    </form>
    ${util.geocoder_feedback(geo=geo_place)}
</div>
</%def>

<%def name="has_alerts(stop)">
<%
    has_alerts = True if 'alerts' in stop and len(stop['alerts']) > 0 else False
    return has_alerts
%>
</%def>

<%def name="stop_title(stop)"><%
    dir_name = ''
    if stop['direction'] and len(stop['direction']) > 0:
        dir_name = _(stop['direction'])
%>${util.name_city_str_from_struct(stop)} ${dir_name}</%def>

<%def name="make_name_id(stop)">
<%
    name = "{0} {1}".format(_(u'Stop ID').encode('utf-8'), stop['stop_id']).decode('utf-8')
    return name
%>
</%def>

<%def name="make_url_params(stop)">
<%
    params = "stop&name={0}&lat={1}&lon={2}".format(stop['name'], stop['lat'], stop['lon'])
    return params
%>
</%def>

<%def name="planner_walk_link(frm, to, text, extra_params)">
<a href="planner_walk.html?mode=WALK&from=${util.make_named_coord_from_obj(frm)}&to=${util.make_named_coord_from_obj(to)}${extra_params}">${text}</a>
</%def>

##
## NOTE: rte_url_tmpl is a closure method passed into routes_served.  
##       @see utils.agency_template.py for more info...
##
<%def name="route_abrv_list(stop, rte_url_tmpl)">
    %for i, r in enumerate(stop['short_names']):
        <a target="#" href="${rte_url_tmpl(r['route_id'])}">${r['route_short_name']}</a>${', ' if i < (len(stop['short_names']) - 1) else ''}
    %endfor
</%def>
<%def name="routes_served(stop, rte_url_tmpl)">
    %if rte_url_tmpl and stop and 'short_names' in stop and stop['short_names']:
        ${_(u'Served by')}: ${route_abrv_list(stop, rte_url_tmpl)}
    %endif
</%def>

##
## show a list of stops (used by nearest_stops.html) 
##
<%def name="stops_list(list, rte_url_tmpl, more_link, params, extra_params)">
<ul id="stopslist" class="group">
    %if list and 'stops' in list:
    %for s in list['stops']:
    <li>
        <h3 class="tight">
            <a href="stop.html?stop_id=${s['stop_id']}${extra_params}" title="${_(u'Show more information about this stop/station')}">${s['name']} ${s['direction']}</a>
            <span class="stopid">${_(u'Stop ID')} ${s['stop_id']}</span>
        </h3>
        <p>${round(s['distance'], 2)} ${_(u'miles away')} <span class="separator">&nbsp;&bull;&nbsp;</span> ${routes_served(s, rte_url_tmpl)} <span class="separator">&nbsp;&bull;&nbsp;</span> ${planner_walk_link(place, s, _('Walking directions'), extra_params)}</p>
    </li>
    %endfor
    %endif

    %if more_link:
    <li>
        <p align="center"><a href="stops_near.html?has_geocode=true&show_more=true&${util.prep_url_params(params)}${extra_params}">${_(u'Show more stops')}</a></p>
    </li>
    %endif
</ul>
</%def>

<%def name="nearby_stops_link(stop, extra_params)">
    <p><a href="stops_near.html?has_geocode=true&place=${util.make_named_coord_from_obj(stop)}${extra_params}">${_(u'Find nearby stops')}</a></p>
</%def>

## static map block
<%def name="static_map_img(map_url)"><img src="${map_url}" alt="${_(u'Stop location on a map')}"/></%def>

<%def name="imap_a_link(name, lon, lat, extra_params, imap_cls=False)"><a ${'class="interactivemap"' if imap_cls else '' | n} target="#" href="http://ride.trimet.org/?zoom=16&pLat=${lat}&pLon=${lon}&pText=${name}${extra_params}" onClick="_gaq.push(['_trackEvent', 'TripPlanner', 'InteractiveMapLink', 'Stop page link']);"></%def>
<%def name="imap_a_link_via_stop(stop, extra_params, imap_cls=False)">${imap_a_link(stop['name'], stop['lon'], stop['lat'], extra_params, imap_cls)}</%def>


<%def name="staticmap_imap_link(name, lon, lat, extra_params, map_url)">
<p>
    ${imap_a_link(name, lon, lat, extra_params)}
        ${static_map_img(map_url)}
    </a>
</p>
<p>
    ${imap_a_link(name, lon, lat, extra_params, True)}
       <span class="imap-text">${_(u'View on Interactive Map')}</span>
    </a>
</p>
</%def>

<%def name="map_and_links(map_url, name, lon, lat, extra_params, is_mobile)">
<%
    if is_mobile:
        static_map_img(map_url)
    else:
        staticmap_imap_link(name, lon, lat, extra_params, map_url)
%>
</%def>

## places map with lat/lon
<%def name="place_map(name, lon, lat, extra_params='', is_mobile=False)">
<%
    w=665
    h=350
    if is_mobile:
        w=300
        h=240
    map_url = "http://ride.trimet.org/eapi/ws/V1/mapimage/format/png/width/{0}/height/{1}/zoom/8/coord/{2},{3}/extraparams/f\
ormat_options=layout:place".format(w, h, lon, lat)
    map_and_links(map_url, name, lon, lat, extra_params, is_mobile)
%>
</%def>

## stops map with lat/lon
<%def name="stop_map(name, stop_id, lon, lat, extra_params='', is_mobile=False)">
<%
    w=340
    h=300
    if is_mobile:
        w=300
        h=240
    map_url = "http://ride.trimet.org/eapi/ws/V1/stopimage/format/png/width/{0}/height/{1}/zoom/6/extraparams/format_options\
=layout:scale/id/{2}".format(w, h, stop_id)
    map_and_links(map_url, name, lon, lat, extra_params, is_mobile)
%>
</%def>

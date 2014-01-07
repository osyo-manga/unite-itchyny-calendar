scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let g:unite#sources#itchyny_calendar#default_year_range = get(g:, "unite#sources#itchyny_calendar#default_year_range", range(2000, 2020))


function! s:flatten(list)
	let result = []
	for _ in a:list
		if type(_) == type([])
			let result += _
		else
			let result += [_]
		endif
		unlet _
	endfor
	return result
endfunction


function! s:flatten_extend(list)
	let result = {}
	for _ in a:list
		if type(_) == type({})
			call extend(result, _)
		endif
		unlet _
	endfor
	return result
endfunction


function! s:get_events(...)
	let years  = get(a:, 1, copy(g:unite#sources#itchyny_calendar#default_year_range))
	let months = get(a:, 2, range(1, 12))
	let events = s:flatten(map(copy(years), 'filter(map(copy(months), "calendar#event#new().get_events_one_month(" . v:val . ", v:val)"), "!empty(v:val)")'))
	let events_dict = s:flatten_extend(events)
	return s:flatten(map(items(events_dict), 'map(v:val[1].events, "[" . string(v:val[0]) . ", v:val]")'))
endfunction



let s:sources = []

let s:source = {
\	"name" : "itchyny/calendar/event/all",
\	"max_candidates" : 100,
\}

function! s:source.gather_candidates(args, context)
	let events = s:get_events()
	return map(events, '{
\		"word" : v:val[0] . " : " . v:val[1].summary,
\		"source__itchyny_calendar_event" : v:val[1],
\		"kind" : "itchyny_calendar",
\		"default_action" : "open_calendar",
\	}')
endfunction

let s:sources += [ s:source ]
unlet s:source



let s:source = {
\	"name" : "itchyny/calendar/event/year",
\	"max_candidates" : 100,
\}


function! s:source.gather_candidates(args, context)
	let year = get(a:args, 0, str2nr(strftime("%Y")))
	let events = s:get_events([year])
	return map(events, '{
\		"word" : v:val[0] . " : " . v:val[1].summary,
\		"source__itchyny_calendar_event" : v:val[1],
\		"kind" : "itchyny_calendar",
\		"default_action" : "open_calendar",
\	}')
endfunction

let s:sources += [ s:source ]
unlet s:source



let s:source = {
\	"name" : "itchyny/calendar/event/new",
\	"action_table" : {
\		"new_event" : {
\			"is_selectable" : 0,
\		},
\	},
\	"default_action" : "new_event"
\}


function! s:source.action_table.new_event.func(candidate)
	let year = input("Year > ")
	if year == ""
		let year = strftime("%Y")
	endif
	let month = input("Month > ")
	if month == ""
		let month = "1"
	endif
	let day = input("Day > ")
	execute "Calendar" year month day
endfunction


function! s:source.gather_candidates(args, context)
	return [{
\		"word" : "[new event]",
\	}]
endfunction

let s:sources += [ s:source ]
unlet s:source


let s:source = {
\	"name" : "itchyny/calendar/event/today",
\}


function! s:source.gather_candidates(args, context)
	return [{
\		"word" : "[today]",
\		"source__itchyny_calendar_event" : {
\			"ymd" : [strftime("%Y"), strftime("%m"), strftime("%d")]
\		},
\		"kind" : "itchyny_calendar",
\		"default_action" : "open_calendar",
\	}]
endfunction

let s:sources += [ s:source ]
unlet s:source



function! unite#sources#itchyny_calendar#define()
	return s:sources
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

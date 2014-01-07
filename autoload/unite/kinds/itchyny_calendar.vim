scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim



let s:kind = {
\	"name" : "itchyny_calendar",
\	"default_action" : "start_calendar",
\	"action_table" : {
\		"open_calendar" : {
\			"is_selectable" : 0,
\		}
\	},
\}


function! s:kind.action_table.open_calendar.func(candidate)
	execute ":Calendar" join(a:candidate.source__itchyny_calendar_event.ymd)
endfunction


function! unite#kinds#itchyny_calendar#define()
	return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

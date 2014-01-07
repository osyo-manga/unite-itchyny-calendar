#unite-itchyny-calendar

##Requirement

* [itchyny/calendar.vim](https://github.com/itchyny/calendar.vim)
* [Shougo/unite.vim](https://github.com/Shougo/unite.vim)

##Example

####All events.

```vim
" default 2000 ~ 2020 years.
:Unite itchyny/calendar/event/all
```

####Events for any year.

```vim
" This year.
:Unite itchyny/calendar/event/year

" 2013 year.
:Unite itchyny/calendar/event/year:2013
```






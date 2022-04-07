-module(miFrame4).
-export([start/0]).
-export([funDevolver/2]).
-export([funBD/2]).
-export([handle_click/2]).

-include_lib("wx/include/wx.hrl").

start() ->
%%Se crea elemento de ventana
wx:new(),
%%Se crea elemento frame 
F = wxFrame:new(wx:null(), 1001, " -== Fomulario JR ==-"),
%% Etiqueta 1
 Etiqueta1 = wxTextCtrl:new(F, 1001, 
 [{value, "Datin"}, {size, {300,80}} ,  {pos, {0, 30} } ]),
%%Atributos etiqueta
 Font = wxFont:new(20, ?wxFONTFAMILY_DEFAULT, ?wxFONTSTYLE_NORMAL,
 ? wxFONTWEIGHT_BOLD),
%%Asignar atributos a etiqueta 
wxTextCtrl:setFont(Etiqueta1, Font),



%%Boton
Boton1 = wxButton:new(F, 1001, [{label, "Agregar"},  {pos, {0, 200} }]),
%% Agregar funcion a boton
%%Funcion anonima
%%FooBar = funDevolver/2 , 
%%wxButton:connect(Boton1, command_button_clicked, [{callback, fun funDevolver/2} , {1, 2} ]),
wxButton:connect(Boton1, command_button_clicked,
 [{callback, fun funBD/2}, {userData,
some_user_data} ]),

%%Segundo boton
 Button = wxButton:new(F, 1001, [{label, "Start"}, {pos,{0, 400}},
{size, {150, 50}}]),

wxButton:connect(Button, command_button_clicked, [{callback, fun
handle_click/2}, {userData, #{etiqueta1 => Etiqueta1, env => wx:get_env()}}]),


 
%%Mostrar ventana desplegar
wxFrame:show(F).

%%Segunda funcion
funDevolver(P1,P2) ->
 io:format("called back with ~nA:~n~p~nB:~n~p~n", [P1,P2]).

%%Funcion de conexion
funBD(P1,P2)  ->
odbc:start(),
%% Value =  list_to_integer( wxTextCtrl:getValue(Etiqueta1) ),
%% Valor2 =  io_lib:format("~p",[Value]),
{ok, Ref} = odbc:connect("DSN=mysqldr;UID=root;PWD=", []),
Respuesta = odbc:param_query(Ref,"INSERT INTO soldado (id_s, nombre "
 ") VALUES(?, ?)",
 [{sql_integer,[2,3,4,5,6,7,8]},
 {{sql_varchar,10},
 ["John", "Monica", "Ross", "Rachel",
 "Piper", "Prue", "uni"]}
 ]),
 odbc:disconnect(Ref),
 odbc:stop(),
 io:format("Parametros  ~nA:~n~p~nB:~n~p~nRef:~n~p~nnRes:~n~p~n", [P1,P2,Ref,Respuesta]).


handle_click(#wx{obj = Button, userData = #{etiqueta1 := Etiqueta1, env := Env}},
 _Event) ->
  wx:set_env(Env),
 Label = wxButton:getLabel(Button),
 EtiquetaN = list_to_integer(wxTextCtrl:getValue(Etiqueta1)),
  io:format("Parametros  ~nRef:~n~p~nRes:~n~p~n", [Label,EtiquetaN]).

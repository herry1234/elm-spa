import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

main =
  Html.program
    { init = init "51807817addd199c08000002"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- Model

type alias Model =
 {
  books: List Book
  , status : String
 }
type alias Book =
  { id : String
  , name : String
  , booktype : String
  , country: String
  , lang: String
  , year: String
  , desc: String
  }
myBook : Book
myBook = { id = "1234"
  , name = "test"
  , booktype = "SCI-FI"
  , country = "CN"
  , lang = "CHN"
  , year =  "1997"
  , desc = "This is test"
  }
myBooks : Model
myBooks = {books = [
  { id = "1234"
  , name = "test"
  , booktype = "SCI-FI"
  , country = "CN"
  , lang = "CHN"
  , year =  "1997"
  , desc = "This is test"
  },
  { id = "4321"
  , name = "test"
  , booktype = "SCI-FI"
  , country = "CN"
  , lang = "CHN"
  , year =  "1997"
  , desc = "This is test"
  }]
  , status = "OK"}
  
init : String -> (Model, Cmd Msg)
init id =
  ( myBooks
  , getBooks
  )

-- UPDATE


type Msg
  = NewBooks (Result Http.Error (List Book))

type MsgBook
  =  NewBook (Result Http.Error Book)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewBooks (Ok mybooks) ->
      ({model | books = mybooks}, Cmd.none)
    NewBooks (Err e) ->
      ({model | status = toString e}, Cmd.none)



-- VIEW

view: Model -> Html Msg
view model =
  div []
  [viewBooks model.books]

viewBooks: List Book -> Html Msg 
viewBooks books =
   ul []
    (List.map viewBookDetail books)
   

viewBookDetail : Book -> Html Msg
viewBookDetail book =
  div []
    [ h2 [] [text "details"]
    , br [] []
    , div [] [ text ("ID : " ++ book.id) ]
    , div [] [ text ("Name : " ++  book.name) ]
    , div [] [ text ("Type : " ++ book.booktype) ]
    , div [] [ text ("Country : " ++ book.country) ]
    , div [] [ text ("Year: " ++ book.year) ]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

getBooks: Cmd Msg
getBooks = 
  let
    url =
      "http://localhost:3000/books"
  in
    Http.send NewBooks (Http.get url decodeGetBooks)
decodeGetBooks : Decode.Decoder (List Book)
decodeGetBooks = 
  Decode.list decodeGetBook
getBookInfo : String -> Cmd MsgBook
getBookInfo id =
  let
    url =
      "http://localhost:3000/books/" ++ id
  in
    Http.send NewBook (Http.get url decodeGetBook)
decodeGetBook : Decode.Decoder Book
decodeGetBook =
  Decode.map7 Book
    (Decode.at [ "_id" ] Decode.string)
    (Decode.at ["name"] Decode.string)
    (Decode.at ["type"] Decode.string)
    (Decode.at ["country"] Decode.string)
    (Decode.at ["language"] Decode.string)
    (Decode.at ["year"] Decode.string)
    (Decode.at ["description"] Decode.string)

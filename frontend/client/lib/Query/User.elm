module Query.User exposing (Data, query)

import Api.Object
import Api.Object.User as User
import Api.Query as Query
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)


query : SelectionSet Data RootQuery
query =
    Query.user userSelection
        |> SelectionSet.nonNullOrFail


type alias Data =
    { name : String
    , password : String
    , passwordAgain : String
    }


userSelection : SelectionSet Data Api.Object.User
userSelection =
    SelectionSet.succeed Data
        |> SelectionSet.with User.username
        |> SelectionSet.with User.password
        |> SelectionSet.with User.passwordAgain

module Box
    ( start, simplebox, box, fxBox
    , withFx, withAllFx, withParentFx
    , update, updateChildren, noFxUpdate, updateChild, updateChildrenNoFx
    , viewChild, viewChildren
    , nextId, ID, ChildList
    , noFx, tick, task, batchFx, sendToParent
    , Config, App, RootAction, Tasks, Effects, rootAction) where

{-| This module helps you start your application in a typical Elm workflow.
It assumes you are following [the Elm Architecture][arch] and using
[elm-effects][]. From there it will wire everything up for you!

**Be sure to [read the Elm Architecture tutorial][arch] to learn how this all
works!**

[arch]: https://github.com/evancz/elm-architecture-tutorial
[elm-effects]: http://package.elm-lang.org/packages/evancz/elm-effects/latest

# Start your Application
@docs start, Config, App

-}

import Html exposing (Html)
import Task exposing (Task)
import Effects
import Time

{-| The configuration of an app follows the basic model / update / view pattern
that you see in every Elm program.

The `init` transaction will give you an initial model and create any tasks that
are needed on start up.

The `update` and `view` fields describe how to step the model and view the
model.

The `inputs` field is for any external signals you might need. If you need to
get values from JavaScript, they will come in through a port as a signal which
you can pipe into your app as one of the `inputs`.
-}
type alias Config model action parentAction =
    { init : (model, Effects action)
    , update : action -> model -> (model, (Effects action, Effects parentAction))
    , view : Signal.Address action -> model -> Html
    , inputs : List (Signal.Signal action)
    }

type RootAction = RootAction

type alias ID = Int

type alias ChildList a = List (ID, a)

type alias Tasks = Signal (Task Effects.Never ())

type alias Effects a = Effects.Effects a

batchFx : List (Effects.Effects a) -> Effects.Effects a
batchFx = Effects.batch

noFx : Effects.Effects a
noFx = Effects.none

tick : (Time.Time -> a) -> Effects.Effects a
tick = Effects.tick

task : Task Effects.Never a -> Effects.Effects a
task = Effects.task

sendToParent : a -> Effects.Effects a
sendToParent action = task (Task.succeed action)

{-| An `App` is made up of a couple signals:

  * `html` &mdash; a signal of `Html` representing the current visual
    representation of your app. This should be fed into `main`.

  * `model` &mdash; a signal representing the current model. Generally you
    will not need this one, but it is there just in case. You will know if you
    need this.

  * `tasks` &mdash; a signal of tasks that need to get run. Your app is going
    to be producing tasks in response to all sorts of events, so this needs to
    be hooked up to a `port` to ensure they get run.
-}
type alias App model =
    { html : Signal Html
    , model : Signal model
    , tasks : Tasks
    }


{-| Start an application. It requires a bit of wiring once you have created an
`App`. It should pretty much always look like this:

    app =
        start { init = init, view = view, update = update, inputs = [] }

    main =
        app.html

    port tasks : Signal (Task.Task Never ())
    port tasks =
        app.tasks

So once we start the `App` we feed the HTML into `main` and feed the resulting
tasks into a `port` that will run them all.
-}
start : Config model action parentAction -> App model
start config =
    let
        singleton action = [ action ]

        -- messages : Signal.Mailbox (List action)
        messages =
            Signal.mailbox []

        -- address : Signal.Address action
        address =
            Signal.forwardTo messages.address singleton

        -- updateStep : action -> (model, Effects action) -> (model, Effects action)
        updateStep action (oldModel, accumulatedEffects) =
            let
                (newModel, (additionalEffects, parentFx)) = config.update action oldModel
            in
                (newModel, Effects.batch [accumulatedEffects, additionalEffects])

        -- update : List action -> (model, Effects action) -> (model, Effects action)
        update actions (model, _) =
            List.foldl updateStep (model, noFx) actions

        -- inputs : Signal (List action)
        inputs =
            Signal.mergeMany (messages.signal :: List.map (Signal.map singleton) config.inputs)

        -- effectsAndModel : Signal (model, Effects action)
        effectsAndModel =
            Signal.foldp update config.init inputs

        model =
            Signal.map fst effectsAndModel
    in
        { html = Signal.map (config.view address) model
        , model = model
        , tasks = Signal.map (Effects.toTask messages.address << snd) effectsAndModel
        }


simplebox : model -> (action -> model -> model) -> (Signal.Address action -> model -> Html) -> Config model action parentAction
simplebox init update view =
    { init = (init, noFx)
    , update = (\a m -> (update a m, (noFx, noFx)))
    , view = view
    , inputs = []
    }

box : (model, Effects action)
    -> (action -> model -> (model, (Effects action, Effects parentAction)))
    -> (Signal.Address action -> model -> Html)
    -> List (Signal action)
    -> Config model action parentAction
box init update view inputs=
    { init = init
    , update = update
    , view = view
    , inputs = inputs
    }

fxBox : (action -> parentAction)
    -> (model, Effects action)
    -> (action -> model -> (model, (Effects action, Effects parentAction)))
    -> (Signal.Address action -> model -> Html)
    -> List (Signal action)
    -> (Config model action parentAction, Effects parentAction)
fxBox toParentAction init update view inputs =
  let
    (_, firstFx) = init
  in
    (box init update view inputs, Effects.map toParentAction firstFx)

update : action -> Config model action parentAction-> (Config model action parentAction, (Effects action, Effects parentAction))
update action cfg =
    let
        (model, fstFx) = cfg.init
        (model', (fx, parentFx)) = cfg.update action model
    in
        ({cfg | init = (model', fstFx)}, (fx, parentFx))

withParentFx : (a -> pa)
    -> (a -> m -> (m, Effects a))
    -> (a -> m -> (m, (Effects a, Effects pa)))
withParentFx toParentAction update action model=
    let
        (model', fx) = update action model
    in
        (model', (fx, noFx))

withFx : (a -> m -> m)
    -> (a -> m -> (m, Effects a))
withFx update action model =
    (update action model, noFx)

withAllFx : (a -> pa)
    -> (a -> m -> m)
    -> (a -> m -> (m, (Effects a, Effects pa)))
withAllFx toParentAction = withFx>>(withParentFx toParentAction)

noFxUpdate : action -> Config model action parentAction-> Config model action parentAction
noFxUpdate action model = fst <| update action model

viewChild : Signal.Address parentAction -> (action -> parentAction) -> Config model action parentAction -> Html
viewChild address toParentAction cfg = cfg.view (Signal.forwardTo address toParentAction) (fst cfg.init)

rootAction : a -> RootAction
rootAction a = RootAction

updateChild : (action -> parentAction) -> action -> Config model action parentAction' -> (Config model action parentAction', Effects parentAction)
updateChild toParentAction action child =
    let
        (child', (fx, pFx)) = update action child
    in
        (child', Effects.map toParentAction fx)

updateChildren : (ID -> action -> parentAction) -> ID -> action -> List (ID, Config model action parentAction) -> (List (ID, Config model action parentAction), Effects parentAction)
updateChildren toParentAction id childAction children =
    let
        updateChild (childID, child) =
            if childID == id then
                let
                    (child', (fx, pFx)) = update childAction child
                 in
                    ((childID, child'), (Effects.map (toParentAction id) fx, pFx))
             else
                ((childID, child), (noFx, noFx))

        (children', fxTupples) = List.unzip <| List.map updateChild children

        fx = List.foldl (\(fx1, fx2) fxs -> fx1::fx2::fxs) [] fxTupples
    in
        (children', Effects.batch fx)

updateChildrenNoFx : (ID -> action -> parentAction) -> ID -> action -> List (ID, Config model action parentAction) -> List (ID, Config model action parentAction)
updateChildrenNoFx toParentAction id childAction children = fst <| updateChildren toParentAction id childAction children

viewChildren : Signal.Address parentAction -> (ID ->action->parentAction) -> List (ID, Config model action parentAction) -> List Html
viewChildren address toParentAction children =
    let
        childView (id, child) =
            viewChild address (toParentAction id) child
    in
        List.map childView children


nextId : (List (ID, Config model action parentActio)) -> ID
nextId xs =
  let
    max = List.maximum <| fst <|List.unzip xs
  in
    case max of
      Nothing -> 0
      Just m -> m+1

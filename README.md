![Language](https://img.shields.io/badge/Language-Swift-orange.svg)

# REDUX SAMPLE

Redux Sample is an open source project to test Redux architecture and its components.

[Redux Sample data source](https://github.com/cmvicentehe/ToDo_API)

# 1. What is Redux?

Redux is a predictable state container. What does it mean? There is an only source of truth (***State***) and there is only one way to modify it (***Reducers***).

The main goal for this architecture is to allow graphic interface display the information with a right state handling.

Redux is composed by the following components (***State, Store, Action dispatcher, Actions, Reducers***)

### Redux Flow

![](https://github.com/cmvicentehe/ReduxSample/blob/develop/documentation-assets/redux_flow.png?raw=true)

### Principles

* There is an only object that stores all of the app information (***Store***).
* State is inmutable.
* State can be modified through ***Reducers***. After an action has been emited.
* Uses pure funcions called ***Reducers***.
* An ***Action*** is the intent to change the ***State***.

# 2. Components

### State

The state is composed by all of the values stored by the application (information requested to web services, databases, cached information, state of the views (loading, displaying information, editting...etc)... etc). This information is inmutable. That means that each time we want to modify the state a new State with the required information must be created and stored.

Our app must have an object that implements ***State protocol***.

```swift
protocol State {}
```

For example: 

```swift
struct AppStateImpl {
    
    private(set) var taskList: [ToDoTask]
    private(set) var selectedTask: ToDoTask?
    private(set) var navigationState: NavigationState?
    private(set) var taskSelectionState: TaskSelectionState = .notSelected
    private(set) var viewState: ViewState
    private(set) var networkClient: NetworkClient
}

extension AppStateImpl: State {}
```

### Store

* It is an object that contains the ***State*** of the app. 
* It has to be unique and inmutable. 
* Offers one function `getState()` that returns one inmutable instance of the current state.
* Offers one function `dispatch(action: Action)` that executes the action passed as a parameter.
* Establishes the relation between te intententions to modify the ***State*** (***Action***) and the way to do it (***Reducers***).

Our app store must have an object that implements ***Store*** protocol.

```swift

protocol Store {

    var suscriptors: [StoreSuscriptor] { get set }

    func suscribe(_ suscriptor: StoreSuscriptor)
    func unsuscribe(_ suscriptor: StoreSuscriptor)
    func getState() -> State
    func dispatch(action: Action)
    func replaceReducer(reducer: @escaping Reducer)
}
```

For example: 

```swift
class AppStore {

    var suscriptors: [StoreSuscriptor]
    let queue: DispatchQueue
    private(set) var reducer: Reducer
    private var state: State {
        didSet {
            notify(newState: state)
        }
    }

    init(reducer: @escaping Reducer, state: State, suscriptors: [StoreSuscriptor], queue: DispatchQueue) {

        self.reducer = reducer
        self.state = state
        self.suscriptors = suscriptors
        self.queue = queue
    }

    deinit {
        suscriptors.forEach { unsuscribe($0) }
    }
}

extension AppStore: Store {

    func suscribe(_ suscriptor: StoreSuscriptor) {
		 ...
    }

    func unsuscribe(_ suscriptor: StoreSuscriptor) {
		...
    }

    func getState() -> State {
		...
    }

    func dispatch(action: Action) {
		...
    }

    func replaceReducer(reducer: @escaping Reducer) {
    	...
    }
}
```

#### Store suscriptor

It is an object that listens to state changes. it must implement ***StoreSuscriptor protocol***.

```swift
protocol StoreSuscriptor {

    var identifier: String { get }

    func update(state: State)
}

```

### Action dispatcher

* It is an object that calls `func dispatch(action: Action)` function from ***Store***
* Our app must have an object that implements ***ActionDispatcher*** protocol.

```swift
protocol ActionDispatcher {
    func dispatch(action: Action)
}
```

### Action

* One ***Action*** expresses the intention to modify the ***State***.
* One ***Action*** has to be a simple object.
* Actions must implement ***Action*** protocol

```swift
protocol Action {
    func execute(for reducer: @escaping Reducer) -> State
}

extension Action {

    func execute(for reducer: @escaping Reducer) -> State {
        
        guard let state = AppDelegateUtils.appDelegate?.store?.getState() else {
            fatalError("State can´t be nil")
        }

        return reducer(self, state)
    }
}
```

For example:

```swift
struct AddTaskAction {}

extension AddTaskAction: Action {}

```

* If we need some information to be accessed from ***Reducer*** it has to be passed as a parameter.

For example:

```swift
struct ChangeSelectedTaskNotesAction {
    
    let taskIdentifier: String
    let taskNotes: String
}

extension ChangeSelectedTaskNotesAction: Action {}
```

### Reducer

* One ***Reducers*** is one pure function that defines how has to change the current ***State***
* One ***Reducer*** is executed when an action is launched.
* One ***Reducer*** has this sign `func <nameOfReducer>(state: State, action: Action) -> State`.

For example:

```swift
func addTaskReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    let taskList = currentState.taskList
    let identifier = UUID().uuidString

    let task = ToDoTask(identifier: String(identifier),
                        name: "",
                        dueDate: nil,
                        notes: nil,
                        state: .toDo)
    
    return AppStateImpl(taskList: taskList,
                        selectedTask: task,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .addingTask,
                        viewState: .notHandled,
                        networkClient: currentState.networkClient)
}
```

# 3. How it works

To create one complete flow in one app you have to follow this steps: 

1. Subscribe your component to changes in app ***State***.

```swift
 guard let appDelegate = AppDelegateUtils.appDelegate else {
            return
        }
        
 appDelegate.suscribe(self)
```

2. Replace active ***Reducer*** stored in the ***Store*** by the required ***Reducer***.

```swift
 func replaceReducerByAddTaskReducer() {
        
        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: addTaskReducer)
    }
```

3. Create a new ***Action***.

```swift
let addTaskAction = AddTaskAction()
```

4. Call ***ActionDispatcher*** `func dispatch(action: Action)` function with the new ***Action***.

```swift
dispatch(action: addTaskAction)
```

5. React to this ***State*** change by implementing `func update(state: State)` from `StoreSuscriptor` protocol.

```swift
extension <NameOfTheSuscriptor>: StoreSuscriptor {
    
    var identifier: String {
        
        let type = <NameOfTheSuscriptor>.self
        return String(describing: type)
    }
    
    func update(state: State) {
        
        guard let newState = state as? AppState else {
            fatalError("There is no a valid state")
        }
        
        self.state = newState
        
        ... // TODO: React to state changes
    }
}
```



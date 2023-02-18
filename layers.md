### Data Flow 

```mermaid
graph TD;
    Coordinators-->Modules;
    Modules-->Services;
    Services-->API;
    API-->Networking;
```
- Coodinators only can have temporary data to make full flow
- Presenters of module can have inside services which provide him a full module data
- Services can use pubilc networking api off app
- API use networking layer. API class also can be singleton
- Imdependent part of programm

### Dependency Flow

```mermaid
graph TD;
  Coordinators-->Modules;
  Coordinators-->Navigation;
    Modules-->Presenters;
    Modules-->CorePresenters;
    Modules-->ViewControllers;
    Modules-->CoreViewControllers;
    Modules-->ModuleBuilder;

    CorePresenters-->API_Services;
    Presenters-->API_Services;
      API_Services-->Models;
      API_Services-->Networking;
     
    ViewControllers-->CoreUI;
    CoreViewControllers-->CoreUI;
    ViewControllers-->UI_Framework;
    CoreViewControllers-->UI_Framework;
```



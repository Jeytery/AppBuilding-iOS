# MVVM

Этот UI архитектурный паттерн используеться чаще всего в связке с RxSwift или Combine. В ином случае это все превращается в MVP. 
На самом деле если добавить реативщину в MVP, то она очень быстро станет MVVM. \
\
Добавляя реативищну к VIPER, мы получим сильно прокачанный MVVM с блэкджэком и интеркаторами. На самом деле такую солянку даже страшно представить, правда, если ViewModel начнет быть сильно массивной, то частичное или полное воплощение VIPER должно помочь распилить ее на более маленькие сущности \
\
Абстрактно вся концепция звучит так. View отдает юай ивенты, ViewModel получает юай ивенты, обрабатывает, реализуеют безнеслогику итд. Реакция на ивенты от ViewModel может быть разная, в зависимости от трактовки (об этом подробнее в примерах). ViewModel может спокойно отдавать ивенты, на который View нужно будет реагировать (что мне не очень нравится). Так же есть сценарий где ViewModel просто использует протокол, который реализует юай. Тогда вью просто должна его конфермить. Такой вариант мне нравиться больше, потому что теперь наша вью очень глупая, ей не надо реагирывать ни на что, просто реализовала все, что от нее требуется по протоколу. \
\
Посмотрим пример двух сценарией MVVM \
\
```вариант 1```
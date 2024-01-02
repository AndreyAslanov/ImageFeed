## ImageFeed

Многостраничное приложение предназначено для просмотра изображений через API Unsplash.

## **Скриншоты**

<img width="433" alt="Снимок экрана 2024-01-02 в 04.45.19" src="https://github.com/AndreyAslanov/ImageFeed/blob/59354d20e73958308fa49c8f414744b107be6c49/Screenshots/Simulator%20Screenshot%20-%20iPhone%2014%20Pro%20-%202024-01-02%20at%2004.45.19.png">

<img width="429" alt="Снимок экрана 2024-01-02 в 04.47.08" src="https://github.com/AndreyAslanov/ImageFeed/blob/59354d20e73958308fa49c8f414744b107be6c49/Screenshots/Simulator%20Screenshot%20-%20iPhone%2014%20Pro%20-%202024-01-02%20at%2004.47.08.png">

<img width="433" alt="Снимок экрана 2024-01-02 в 04.47.25" src="https://github.com/AndreyAslanov/ImageFeed/blob/59354d20e73958308fa49c8f414744b107be6c49/Screenshots/Simulator%20Screenshot%20-%20iPhone%2014%20Pro%20-%202024-01-02%20at%2004.47.25.png">

<img width="427" alt="Снимок экрана 2024-01-02 в 04.47.30" src="https://github.com/AndreyAslanov/ImageFeed/blob/59354d20e73958308fa49c8f414744b107be6c49/Screenshots/Simulator%20Screenshot%20-%20iPhone%2014%20Pro%20-%202024-01-02%20at%2004.47.30.png">

<img width="429" alt="Снимок экрана 2024-01-02 в 04.46.26" src="https://github.com/AndreyAslanov/ImageFeed/blob/59354d20e73958308fa49c8f414744b107be6c49/Screenshots/Simulator%20Screenshot%20-%20iPhone%2014%20Pro%20-%202024-01-02%20at%2004.46.26.png">

<img width="433" alt="Снимок экрана 2024-01-02 в 04.46.31" src="https://github.com/AndreyAslanov/ImageFeed/blob/59354d20e73958308fa49c8f414744b107be6c49/Screenshots/Simulator%20Screenshot%20-%20iPhone%2014%20Pro%20-%202024-01-02%20at%2004.46.31.png">

## Инструкция

Приложение готово к использованию после скачивания, но только после обязательной авторизации через Unsplash. Главный экран состоит из ленты с изображениями, пользователь может просматривать ее, добавлять и удалять изображения из избранного. Можно просматривать каждое изображение отдельно и делиться ссылкой на них за пределами приложения. У пользователя есть профиль с избранными изображениями и краткой информацией о себе.

Важно! Из-за платных ограничений со стороны API, количество запросов в сеть ограничено до 50 в час. Если вдруг приложение выдаст алерт с ошибкой, то скорее всего именно из-за этого.

## Технические требования

- Поддержка устройств iPhone начиная с iOS 13, предусмотрен только портретный режим
- вёрстка под iPad не предусмотрена

Стек: UITableView, ScrollView, WebView, KVO, SPM, Kingfisher, CoreAnimation, MVP, URLSession

## **Ссылки**

- [Дизайн в Figma](https://www.figma.com/file/HyDfKh5UVPOhPZIhBqIm3q/Image-Feed-(YP))
- [Unsplash API](https://unsplash.com/documentation)

X-Date: 2022-03-06T12.00.00 Subject: Построение 3D моделей носимых устройств в Decentraland (общая информация) X-Slug: happy

**Внимание!!** Оригинальная статья [тут](https://docs.decentraland.org/decentraland/creating-wearables/), перевод был выполнен 03.03.2022, перевод не является дословным, в нем присутствуют авторские изменения или дополнения.

Давайте создадим элемент внешнего вида для Decentraland.

Для гарантии стабильной работы Decentraland, важно создавать wearables (носимые устройства, элементы внешнего вида, вещи) без большого количества полигонов. Цель – сохранить баланс между детальностью и простотой отрисовки, рендерингом.

Аналогично по текстурам, чем меньше, тем лучше. 

**Количество используемых полигонов и текстур ограничено:**

+ Не более чем 1,5 тысячи полигонов на одну вещь (кроме категорий связанных с кожей)
+ Не более чем 500 полигонов на один аксессуар 
+ Не больше, чем 2 текстуры (при разрешении 512x512px или ниже) на одну вещь. Все текстуры должны быть квадратными
+	Не более 5 тысяч полигонов для категорий, связанных с кожей, и 5 текстур размером 512x512px или ниже

До того, как вы начнете работу, скачайте примеры [сеток, текстур, вещей](https://drive.google.com/drive/u/0/folders/12hOVgZsLriBuutoqGkIYEByJF8bA-rAU).

### Голова, туловище, ноги (и ступни)

После того, как вы скачаете и загрузите модель, например в Blender. Вы заметите, что каждая модель состоит из 7 разных сеток, относящихся к скелету (armature). Сетки представляют собой голову, брови, глаза, рот, туловище, ноги и ступни. Вы можете использовать модели, как референсы для создания своих собственных вещей.

Важно не изменяйте пропорции между частями тела, если только вы не хотите получить «плавающую» голову.

Вы также можете заметить, что каждая категория имеет заглушки, что поможет вам не внести лишних изменений. Заглушки существуют для предотвращения некорректной работы при создании анимации. Заглушки рекомендуется оставлять.  

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-6.jpg)

Существует 2 основных материалы для модели аватара. Один из материалов используется для вещей, другой для кожи.

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-7.png)

Каждая сетка имеет собственную текстуру кожи (аватар A мужской, B женский).

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-8.png)
Кожа аватара формы А

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-9.png)
Кожа аватара формы B

Вы можете заметить, что кожа рендерится серым цветом, это дает возможность применять тот цвет для кожи, который будет предпочитать пользователь (настройка пользователем происходит при создании аватара, но можно вносить изменения и после). 

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-10.png)

**Важно:** всегда сохранять UV развертку для частей тела, которые не затронуты вещью, например, как ноги, которые остаются открытыми при короткой юбке. Важно, чтобы цвет кожи продолжал оставаться правильным для рендеринга.

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-11.png)

Оставляйте сетку кожи нетронутой и используйте базовую текстуру AvatarWearable_MAT, данная текстура представлена в примерах. Это будет гарантировать что ваши созданные вещи будут корректно отражаться в Decentraland. Однако, Вы можете создавать кастомные текстуры для вещей. Рекомендуется использовать один небольшой файл содержащий все текстуры.

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-12.png)

### Брови, глаза и рот

Сетки бровей, глаз, рта, работают с прозрачным шейдером, потому у вас нет необходимости делать что-то помимо своих png текстур, если вы хотите создать новый стиль для упомянутых выше частей тела. Текстуры должны быть 256x256px и иметь альфа канал (alpha channel) для прозрачности.

Несколько примеров текстур png:

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-13.png)
Глаза

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-14.png)
Брови

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-15.jpg)
Брови

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-16.png)
Рот

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-17.jpg)
Рот

Для достижения финального результата необходимо использовать следующие настройки.

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-18.png)

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-19.png)

Вы можете заметить, что в редакторе аватара есть разные варианты цвета, которые пользователи могут выбирать. 

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-20.png)
Экран настройки глаз аватара в Decentraland

### Волосы и усы

Есть две важные вещи, которые необходимо помнить, когда вы создаете волосы.

+ Старайтесь следовать форме головы. Вы всегда можете воспользоваться сеткой головы, представленной в примерах.

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-23.png)

+ Если вы хотите, чтобы пользователю было доступно изменение цвета кастомных волос или бороды при редактировании аватара, вам необходимо использовать серый оттенок (grayscale). Бледные оттенки серого будут казаться темнее, светлые оттенки серого будут казаться ярче, но всегда в цвете, выбранном пользователем.

### Skin weighting (псевдо кожа)

Skin weighting — это процесс определения, какие кости в основе аватара влияют на носимые вещи, плотно не прилегающие к видимой части тела.
Следует учитывать следующие моменты. Каждый набор вещей должен быть нанесен по скелету. Например, кофта будет выглядеть следующим образом:

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-24.png)

Вещи, которые присутствуют на пересечение частей тела, должны быть полностью привязаны к одной части тела (то есть, например, если у вас комбинезон, он может быть привязан к туловищу). В случае с рубашкой воротник будет привязан к шейной «кости».

![alt text](https://docs.decentraland.org/images/media/creating-wearables-images/creating-wearables-25.png)

Ключевые «кости», которые следует использовать при создании псевдо кожи, являются:

+ Кость головы: для волос, сережек, диадем, глаз, бровей, рта и любых аксессуаров, которые должны следовать за движением головы
+ Кость шеи: в месте пересечения головы и верхней части тела
+ Кость бедра: в месте пересечения ног и туловища
+ Кости правой и левой ног: в месте пересечения туловища и ног

Если вы будете придерживаться этих рекомендаций при создании, вы получите хороший результат.

Помните, что вы можете использовать любую кость для воздействия на вещь, плотно не прилегающую к телу! Например, вы можете создать новую сетку ступни для высоких сапог и прикрепить верхнюю часть сапог к «костям» ног. Или можно создать длинные волосы и использовать «кости» плеча или позвоночника для воздействия на волосы при движении аватара.

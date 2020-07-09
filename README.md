경기도 지역 화폐 가맹점 지도
===================

>이 프로젝트는 재난 지원금 으로 인해 지역화폐가 이슈가 되어서 지역화폐 찾는 지도 하나쯤 있으면 좋겠다 싶어서 만듬

</br>

이번 글에서 앱을 만들면서 MVC패턴을 살펴보고. 앱을 만들면서 필요했던  라이브러리들인 Alamofire에 대한 정보 나아가서 프로젝트를 발전시키기 위해서 했던 노력들을 공유해보고자 한다. 프로젝트에 대해서 궁금한 점이 있거나 부족한 점이 보인다면 연락 언제든지 환영.
이메일: <skh5806@gmail.com>

</br>

목차
-----
[1. 준비](#준비)  

+ 개발 준비 단계. 프로젝트에 대한 추상화 그리고 구체화 방법 모색

[2. 개발](#개발)

+ 실제 개발 단계.  

[3. 발생하는 문제와 해결](#발생하는-문제와-해결)

+ 개발 단계에서 생기는 문제점들과 이들을 해결한 경험. 

[4. 프로젝트 레벨업](#프로젝트-레벨업) 
+ 기술적으로 이 프로젝트를 발전시키기 위한 방안과 노력. 

</br>
</br>

준비
-----
_개발환경_
> + Platform: iOS 
> + Language: Swift 5
> + Library: Alamofire  + RX Swift (v.2) + Realm (v.3)   

</br>

나는 객체 지향 방법론으로 이 프로젝트에 접근하여 개발하기 시작했다. 때문에 객체 지향에 대한 나 나름대로의 설명과 함께 이 프로젝트에 대한 기록을 설명할것.

객체 지향 방법론이란 프로젝트를 접근하는 방법 중 하나인데,  하고자 하는 프로젝트에서  대상화 할 수 있는 개념들을 위주로 생각하는 방법을 말한다. 즉, 어떤 대상들을 만들어서 이를 어떻게 엮어서 개발할것인가하는 방법이다. 또 이 방법론 중에서도 MVC디자인 패턴을 사용하였다.  

개발 파트에서는 이러한 접근법에 따른 얘기들과 또 실제 어떻게 개발했는지, 실제 개발하면서 어떤 어려움을 겪었으며 프로젝트를 업그래이드 시키기 위해서 어떤 노력을 했는지를 써보려고한다.

</br>

### 1.1. 프로젝트 추상화

프로젝트 추상화는 내가 만들 이 프로젝트를 머리속으로 시뮬레이션을 하면서 어떤 구성요소들로 이루어지는지 생각해보는 단계다.  

나는 프로젝트에 처음 접근 할 때 가장 중요한 구성요소들을 생각하여 이 프로젝트를 추상화 한다.
추상화 할 때 나는 내가 만들고자 하는 앱을 상상속에서 사용한다고 혹은 그 상황을 겪는 다고 상상하면서 그 상황이 성립하기 위해 핵심적인 필요한 요소들과 그 상황속에서 요소들이 사용되면서 일어나는 상호작용을 생각한다. 

생각을 잘못하면 이 프로젝트의 방향을 아주 잘못 잡아버리는 것이기 때문에 아주..! 신중하게 생각해야한다. (하지만 어렵다.. 잘못잡아서 개고생한적도 여러번.. 고로 신중히 또 신중히 하자.)

그럼 이제 신중하게 이 프로젝트에 필요한 중요 구성 요소들을 고민해보고 이들을 어떤 상호작용이 일어나는지를 고민해보자. 

</br>

__1.1.1. 중요 객체__

우리가 지도를 이용해 지역화폐 가맹점들을 찾는 상황을 생각해보자.
우리가 전지적 작가 시점에서 앱을 사용하는 상황을 본다고 생각 했을 때 어떤 것이 보일까?  
.  
.  
.  
.  
.  
지도 그리고 지도를 찾는 나 마지막으로 가맹점 즉 가게가 보일 것이다.

그럼 우리가 이 프로젝트를 만들기 위해서 만들 구성 요소는 크게 사용자, 지도, 가게일 것이다. (이 프로젝트에서 개인 별로 특화 되어 제공되는 데이터는 없기 때문에, 예를 들어 즐겨찾기 같은, 사용자객체는 매우 작을것.) 우리는 이런 개념지을 수 있는 구성요소들을 객체라고 한다. 이렇게 고민해서 만들어지는 프로젝트에 필요한  객체들을 Model이라고 한다.

그럼 우리는 이제 이 세개의 객체를 만드는데 우리가 원하는 행동을 위해 각각의 객체가 서로 상호작용하도록 만들면 개발 끝이다! 
개발 참 쉽다. (거짓)

```
* 중요한 3가지 객체 *
1. 지도
2. 가게
3. 사용자
```

</br>

__1.1.2. 행동(상호작용)__

그럼 이제 내가만들고자 하는 프로젝트에서 모델끼리 어떤 상호작용을 할지 하나하나 차근 차근 상상해보자. 

1. 지도-가게

```
1. 지도 위에는 가맹점인 가게 위치가 보여져야한다.
2. 지도 위의 가게를 클릭하면 가게에 대한 정보가 보여져야한다. 
```

지도-가게 상호작용을 본다면 지도 객체는 가게의 위치와 세세한 정보를 가지고 있는 객체가 필요해 보인다.
이말인 즉슨 가게 객체는 각각 가게의 위치와 세세한 정보를 포함하고 있어야한다는 얘기. 
나는 가게 객체로 부터 가게 정보를 받아와서 이 지도에 보여주면 된다. 

</br>

2. 지도-사용자
```
1. 사용자위치를 중심으로 지도를 보여준다.
```
지도-사용자의 상호 작용을 본다면 지도는 사용자의 위치를 중심으로 줌 레벨에 따라 지도의 일부분이 보여져야한다. 그런데 지도와 사용자만으로는 지도의 일부분이 보여진다는 것을 설명하기엔 좀 어색하다. 사용자 객체의 의의 사용자에 대한 정보를 담는 것인데 위치 정보는 그렇다 쳐도 줌 레벨은 뭔가 사용자가 가지기에는 어색한 정보라는 느낌이 있다.  이럴때는 새로운 객체가 필요하다는 뜻이거나 중요 객체를 잘못잡았다는 뜻이다.

여기서는 카메라라는 객체를 추가함으로써 지도의 일부분을 보여주는 상호작용을 할 수 있다. 카메라는 줌, 위치정보를 가지고 지도의 일부분을 보여준다. 카메라는 사용자로 부터 현재 위치를 받아와서 줌 레벨에 따라서 범위를 보여주게 된다.    

카메라의 위치정보는 사용자로부터 받아오면 된다.

</br>

3. 사용자-가게
```
1. 딱히 없다. 각각의 사용자가 모든 가게에 대해 동일한 정보를 받기 때문.  
만약 각각 다른 정보를 받아야한다면 다른 상호작용이 더 필요하겠지.
```

이제 이렇게 정해진 모델들과 모델들을 끼리의 상호작용을 사용자가 사용할 수 있게 만들면 정말 개발 끝이다!

</br>

### 1.2. 프로젝트 구체화 전략: MVC

 머리속으로만 상상했던 정보표현이나 행동들을 우리는 실제 디바이스에서 사용자가 사용하도록 만들어야한다.

 나만의 자동차를 만든다고 상상해보자. 그런데 껍데기는 정해져있고 그 껍데기를 바탕으로 나만의  자동차를 만들어야한다. 상상을 마치고 나면 우리는 깝떼기를 디자인 할것이다. 어디는 어떤 색이고 여기는 이렇게 모양을 바꾸고. 또 엔진은 이런걸 쓰고 어떤 부품은 이런걸 쓰고... 이런 상황에서는 브레이크가 이렇게 잡히고.. 우리가 상상했던 정보를 토대로 차를 만들것이다. 

 앱도 똑같다. 우리는  iOS앱을 통해서 우리가 상상하는 것을 만들것이다.  껍데기를 뷰라고 한다. 이 뷰를 통해 우리는 앱의 시각적인 정보를 얻고 터치를 하면서 사용하게 된다. 그럼 이제 우리는 뷰를 만들고 우리가 원하는 앱을 만들기 위해 우리가 머리속으로 상상한 모델들을 표현하기 위해 뷰를 디자인하고 또 사용자가 사용할 때 취할 행동들을 정하면 된다. 앱에서 이런것들은 데이터를 통해서 정해지는데 이런 정보들을 모델이 가지고 있게 만든다. 그리고 이러한 일련의 작업들을 위 상상에서 자동차를 만들 때는 내가 직접 자동차를 만들었지만 앱에서는 직접할수는 없으니  컨트롤러라는 것이 이러한 작업을 수행하게 하는 것이다..

 이렇게 만들어지다보니 뷰는 단순히 보여지는 껍데기라 껍데기만 똑같다면 다른데서도 사용할 수 있고, 모델도 데이터만 가지고 있는 친구다 보니 필요한 곳에서라면 어디서든 사용할 수 있는 장점도 생긴다.

개발전에 생각할 것이 이렇게 많다.. 그럼 이제 드디어 실제로 경기도 지역화폐 가맹점 지도를 위한 껍데기 뷰, 모델, 컨트롤러를 만들어보자. 

코딩
----

 튜토리얼을 보다보면 보통 뷰부터 만들던데 나는 왜인지 모르게 모델부터 만들게된다. (이게 잘못된 방법이라면 위의 이메일로 쓱 찔러주세요..)
 그럼 이제 모델들을 한번 만들어보자.  프로젝트를 만들기 위해 필요하다고 했던 모델이 뭐가 있었지? 바로 사용자, 지도, 가게이다. 그럼 여기서 편한거 부터 만들면 되는데, 가게 모델부터 한번 만들어보자. 가게 모델이라는 말이 뭔가 어색하니까 뒤에서부터는 Store라고 하겠다.  

__1.3.1. Store__

 우리는 개발자기 때문에 하나의 객체를 구체화 하는데 있어서 데이터를 가지고 먼저 생각해야한다. 

 Store에는 뭐가 필요할까? 우리가 앱을 사용한다고 생각했을 때 보고싶은 데이터들이 있을 것이 아닌가? 우선 가게 이름, 전화번호, 주소 등등이 있을 것이다. 그리고 주소만 가지고 지도에 찍어주기는 힘드니까 위도와 경도가 있으면 지도에 찍기 수월하겠지?  그럼 이제 이 데이터들을 가져와서 우리의 모델 객체에 담아보자.

 ```
 Store에 필요한 데이터
1. 이름
2. 전화번호
3. 주소
4. 위도 경도
 ```

 그럼 이 정보들을 이제 어떻게 어디서 가져올 것인가가 관건이다. 발로 뛰어서? 네이버 지도에서? 운좋게도 공공데이터 포털에서는 이러한 정보를 제공해준다. link: [경기도 지역화폐 가맹 현황](https://data.gg.go.kr/portal/data/service/selectServicePage.do?page=1&rows=10&sortColumn=&sortDirection=&infId=3NPA52LBMO36CQEQ1GMY28894927&infSeq=4&order=&loc=)

 여기서는 다운로드하거나  Open API라는 URL로 서버에 필요 데이터를 호출할 수 있는 방식을 제공한다. 나는 여기에서 URL로 필요 데이터만 호출하여 앱 자]체의 용량을 줄이려고 한다. 

</br>
</br>

발생하는-문제와-해결
----------------------







경기도 지역 화폐 가맹점 지도
===================

>이 프로젝트는 재난 지원금 으로 인해 지역화폐가 이슈가 되어서 지역화폐 찾는 지도 하나쯤 있으면 좋겠다 싶어서 만듬

이번 글에서 앱을 만들면서 MVC패턴을 살펴보고. 앱을 만들면서 필요했던  라이브러리들인 Alamofire에 대한 정보 나아가서 프로젝트를 발전시키기 위해서 했던 노력들을 공유해보고자 한다. 프로젝트에 대해서 궁금한 점이 있거나 부족한 점이 보인다면 연락 언제든지 환영.
이메일: <skh5806@gmail.com>


목차
-----
[1. 개발](#개발)

+ 개발 기획에서 부터 실제 개발까지.  

[2. 발생하는 문제와 해결](#발생하는-문제와-해결)

+ 개발 단계에서 생기는 문제점들과 이들을 해결한 경험. 

[3. 프로젝트 레벨업](#프로젝트-레벨업) 
+ 기술적으로 이 프로젝트를 발전시키기 위한 방안과 노력. 

*

개발
-----
_개발환경_
> + Platform: iOS 
> + Language: Swift 5
> + Library: Alamofire  + RX Swift (v.2) + Realm (v.3)   

*

나는 객체 지향 방법론으로 이 프로젝트에 접근하여 개발하기 시작했다. 때문에 객체 지향에 대한 나 나름대로의 설명과 함께 이 프로젝트에 대한 기록을 설명하고자 한다.

객체 지향 방법론이란 프로젝트를 중요한 대상화 할 수 있는 개념들을 위주로 생각하는 방법을 말한다.

1.개발 파트에서는 내가 어떻게 접근하기 시작했는지 또 어떻게 개발했는지 더 깊이 들어가서 목표를 이루기 위해서 어떻게 개발했으며 어떤 어려움이 있었는지까지 설명해보고자 한다.

객체 지향적인 관점에서 프로젝트를 접근하는 방법들중에 유명한 방법이 몇가지가 있는데 나는 MVC라는 방법을 사용하여 객체들을 어떻게 사용하고 어떻게 화면에 보여줄 것인지를 구분하였다.

*

### 1.1. 프로젝트 추상화

프로젝트 추상화는 내가 만들 이 프로젝트를 머리속으로 시뮬레이션을 하면서 어떤 구성요소들로 이루어지는지 생각해보는 단계다.

나는 프로젝트에 처음 접근 할 때 가장 중요한 구성요소들을 생각하여 이 프로젝트를 추상화 한다.
추상화 할 때 나는 내가 만들고자 하는 앱을 상상속에서 사용한다고 혹은 그 상황을 겪는 다고 상상하면서 그 상황이 성립하기 위해 핵심적인 필요한 요소들과 그 상황속에서 요소들이 사용되면서 일어나는 상호작용을 생각한다. 

생각을 잘못하면 이 프로젝트의 방향을 아주 잘못 잡아버리는 것이기 때문에 아주..! 신중하게 생각해야한다. (하지만 어렵다.. 잘못잡아서 개고생한적도 여러번.. 고로 신중히 또 신중히 하자.)

그럼 이제 신중하게 이 프로젝트에 필요한 중요 객체들을 고민해보고 이들을 어떤 상호작용이 일어나는지를 고민해보자. 

### 1.1.1. 중요 객체

우리가 지도를 이용해 지역화폐 가맹점들을 찾는 상황을 생각해보자. 
이 상황을 우리가 전지적 작가 시점에서 본다고 생각 했을 때 어떤 것이 보일까?
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

*

### 1.1.2. 행동(상호작용)

그럼 이제 내가만들고자 하는 프로젝트에서 모델끼리 어떤 상호작용을 할지 하나하나 차근 차근 상상해보자. 

1. 지도-가게

```
1. 지도 위에는 가맹점인 가게 위치가 보여져야한다.
2. 지도 위의 가게를 클릭하면 가게에 대한 정보가 보여져야한다. 
```

지도-가게 상호작용을 본다면 지도 객체는 가게의 위치와 세세한 정보를 가지고 있는 객체가 필요해 보인다.
이말인 즉슨 가게 객체는 각각 가게의 위치와 세세한 정보를 포함하고 있어야한다는 얘기. 
나는 가게 객체로 부터 가게 정보를 받아와서 이 지도에 보여주면 된다. 

*

2. 지도-사용자
```
1. 사용자위치를 중심으로 지도를 보여준다.
```
지도-사용자의 상호 작용을 본다면 지도는 사용자의 위치를 중심으로 줌 레벨에 따라 지도의 일부분이 보여져야한다. 그런데 지도와 사용자만으로는 지도의 일부분이 보여진다는 것을 설명하기엔 좀 어색하다. 사용자 객체의 의의 사용자에 대한 정보를 담는 것인데 위치 정보는 그렇다 쳐도 줌 레벨은 뭔가 사용자가 가지기에는 어색한 정보라는 느낌이 있다.  이럴때는 새로운 객체가 필요하다는 뜻이거나 중요 객체를 잘못잡았다는 뜻이다.

여기서는 카메라라는 객체를 추가함으로써 지도의 일부분을 보여주는 상호작용을 할 수 있다. 카메라는 줌, 위치정보를 가지고 지도의 일부분을 보여준다. 카메라는 사용자로 부터 현재 위치를 받아와서 줌 레벨에 따라서 범위를 보여주게 된다.    

카메라의 위치정보는 사용자로부터 받아오면 된다.

*


3. 사용자-가게
```
1. 딱히 없다. 각각의 사용자가 모든 가게에 대해 동일한 정보를 받기 때문. 만약 각각 다른 정보를 받아야한다면 다른 상호작용이 더 필요하겠지.
```

*

### 1.2. 코딩 (프로젝트 구체화)

위의 과정들은 머리속으로 프로젝트의 큰그림을 그려보는 과정이였다. 그럼 이 프로젝트를 실제 앱으로 만들기 위해서는 머리속에서 펼쳐지는 상상이 아니라 코딩을 하여 앱으로 옮겨야 한다. 

앱에서 머리속으로만 상상했던 정보표현이나 행동들을 우리는 화면을 통해서 하게된다. 이 화면에서 사용자와 상호작용 할 수 있도록 보여지는 것을  뷰라고 한다. 내가 사용한 MVC 패턴에서는 뷰는 단순히 보여주고 입력을 받는 껍데기일 뿐이다. 뷰에 뭘 보여주고 행동을 어떻게 할지는 데이터로인해서 정해진다. 그럼 이 데이터는 어디서 얻어올까? 위에서 생각한 모델들에서 데이터를 얻어온다. 모델의 데이터는 실제 파일이나 사용자 입력 혹은 서버에서 받아올 수 있다.

위의 말을 다시 정리해보면 뷰 껍데기들은 모델에서 데이터를 받아와서 각 구성요소로써의 개성을 가지게 되고 앱을 구성한다. 
데이터를 가진 모델은 뷰에 데이터를 공급한다. 그런데 여기서 중요한 것은 우리가 추상화 단계에서 만들때, 하나의 뷰를 생각하면서 모델을 만든것이 아니라, 앱 전체를 생각하면서 모델의 개념을 잡았다. 때문에 모델의 객체들은 하나의 뷰 뿐만 아니라 앱전체에서 그 객체의 개념을 필요로 하는 곳에서 사용이 가능하다는 소리가 된다.

이제 뷰와 모델의 개념에서 한발자국 떨어져서 우리가 하나의 화면을 만든다고 했을 때  여러개의 뷰와 여러개의 모델을 사용하게 될 텐데, 이들이 서로 얽히고 설켜서 데이터를 주고 수정하고 보여주고 할텐데 이러한 복잡한 로직을 한곳에서 관리하는데 이것을 컨트롤러라고한다.

*

발생하는-문제와-해결
----------------------







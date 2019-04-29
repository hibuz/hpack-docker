UPDATE enum SET name = 'Bug' WHERE type ='ticket_type' AND value = '1';
UPDATE enum SET name = 'Improvement' WHERE type ='ticket_type' AND value = '2';
UPDATE enum SET name = 'Task' WHERE type ='ticket_type' AND value = '3';
INSERT INTO enum VALUES('ticket_type', 'New Feature', '4');
UPDATE milestone SET name ='0.0.1', description='마일스톤 0.0.1' WHERE name = 'milestone1';
UPDATE milestone SET name ='0.0.2', description='마일스톤 0.0.2' WHERE name = 'milestone2';
UPDATE milestone SET name ='1.0.0', description='마일스톤 1.0.0' WHERE name = 'milestone3';
UPDATE milestone SET name ='1.1.0', description='마일스톤 1.1.0' WHERE name = 'milestone4';
UPDATE version SET name ='0.0.1' WHERE name = '1.0';
UPDATE version SET name ='1.0.0' WHERE name = '2.0';
INSERT INTO repository VALUES(2, 'name', 'git');
INSERT INTO repository VALUES(2, 'dir', '%HPACK_PRJ_GIT%/%PROJECT_NAME%.git');
INSERT INTO repository VALUES(2, 'type', 'git');
INSERT INTO attachment VALUES('wiki', 'TicketGuideline', 'visual-workflow.png', 16514, 1350806306263000, '', 'admin', '127.0.0.1');
INSERT INTO attachment VALUES('wiki', 'HibuzPackManual', 'blueci_structure.png', 17034, 1379086707564322, '', 'admin', '127.0.0.1');

INSERT INTO report VALUES(18,'Timing and Estimation Plugin','Work Summary','SELECT __color__, __style__, ticket, summary, status, owner, start_date, end_date, close_date, estimated_work/8.0 as estimated_day, total_work/8.0 as total_day, estimated_work as estimated_hour, total_work as total_hour, _ord
FROM (
  SELECT p.value AS __color__,
    '''' as __style__,
    t.id AS ticket, summary AS summary,             -- ## Break line here
    status, owner,
	due_assign.value as start_date, due_close.value as end_date, actual_close.value as close_date,
    CASE WHEN EstimatedHours.value = '''' OR EstimatedHours.value IS NULL THEN 0
      ELSE CAST( EstimatedHours.value AS DECIMAL ) END as estimated_work,
    CASE WHEN totalhours.value = '''' OR totalhours.value IS NULL THEN 0
      ELSE CAST( totalhours.value AS DECIMAL ) END as total_work,
    time AS created, changetime AS modified,         -- ## Dates are formatted
    description AS _description_,                    -- ## Uses a full row
    changetime AS _changetime,
    reporter AS _reporter
    ,0 as _ord
    FROM ticket as t
    LEFT JOIN enum as p ON p.name=t.priority AND p.type=''priority''
  LEFT JOIN ticket_custom as due_assign ON due_assign.name=''due_assign''
        AND due_assign.Ticket = t.Id
  LEFT JOIN ticket_custom as due_close ON due_close.name=''due_close''
        AND due_close.Ticket = t.Id
  LEFT JOIN ticket_custom as actual_close ON actual_close.name=''actual_close''
        AND actual_close.Ticket = t.Id
  LEFT JOIN ticket_custom as EstimatedHours ON EstimatedHours.name=''estimatedhours''
        AND EstimatedHours.Ticket = t.Id
  LEFT JOIN ticket_custom as totalhours ON totalhours.name=''totalhours''
        AND totalhours.Ticket = t.Id
  LEFT JOIN ticket_custom as billable ON billable.name=''billable''
        AND billable.Ticket = t.Id
    WHERE t.status IN ($REOPENED, $ASSIGNED, $REVIEWING, $CLOSED, $NEW, $ACCEPTED)
      AND billable.value in ($BILLABLE, $UNBILLABLE)

  UNION

  SELECT ''1'' AS __color__,
         ''background-color:#DFE;'' as __style__,
         0 as ticket, ''Total'' AS summary,
         ''Time Remaining: '' as status,
         CAST(
       SUM(CASE WHEN EstimatedHours.value = '''' OR EstimatedHours.value IS NULL THEN 0
         ELSE CAST( EstimatedHours.value AS DECIMAL ) END) -
       SUM(CASE WHEN totalhours.value = '''' OR totalhours.value IS NULL THEN 0
         ELSE CAST( totalhours.value AS DECIMAL ) END)
         AS CHAR(512))  as owner,
         NULL as start_date,NULL as end_date, NULL as close_date,
         SUM(CASE WHEN EstimatedHours.value = '''' OR EstimatedHours.value IS NULL THEN 0
      ELSE CAST( EstimatedHours.value AS DECIMAL ) END) as estimated_work,
         SUM(CASE WHEN totalhours.value = '''' OR totalhours.value IS NULL THEN 0
      ELSE CAST( totalhours.value AS DECIMAL ) END) as total_work,
         NULL as created, NULL as modified,         -- ## Dates are formatted
         NULL AS _description_,
         NULL AS _changetime,
         NULL AS _reporter
         ,1 as _ord
    FROM ticket as t
    LEFT JOIN enum as p ON p.name=t.priority AND p.type=''priority''
  LEFT JOIN ticket_custom as EstimatedHours ON EstimatedHours.name=''estimatedhours''
        AND EstimatedHours.Ticket = t.Id
  LEFT JOIN ticket_custom as totalhours ON totalhours.name=''totalhours''
        AND totalhours.Ticket = t.Id
  LEFT JOIN ticket_custom as billable ON billable.name=''billable''
        AND billable.Ticket = t.Id
    WHERE t.status IN ($REOPENED, $ASSIGNED, $REVIEWING, $CLOSED, $NEW, $ACCEPTED)
      AND billable.value in ($BILLABLE, $UNBILLABLE)
)  as tbl
ORDER BY  _ord ASC, ticket
    ','Reports Must Be Accessed From the Management Screen');

UPDATE wiki SET text ='[[PageOutline]]

= 1. 샘플 프로젝트 개요 =
여기에 프로젝트 개요를 입력합니다.

= 2. 최근 뉴스 =
 * (2013-10-01) [배포] Blue CI 1.0 을 발표하였습니다.
 * (2013-07-01) [회의] [wiki:MeetingNote20130701 Project Kickoff]
 * (2013-01-01) [공지] 개발 홈페이지를 오픈하였습니다.

= 3. 다운로드 =
 * SVN : [/svn/%PROJECT_NAME%/releases/0.0.1/%PROJECT_NAME%.jar %PROJECT_NAME% 0.0.1 다운로드], Trac Browser : [source:/git/releases/0.0.1/%PROJECT_NAME%.jar %PROJECT_NAME% 0.0.1]
 * Release Notes: [wiki:ReleaseNotes 보기] | Previous Releases: [source:/releases/ 보기]

= 4. 프로젝트 관리 =
 * [/roadmap 프로젝트 전체 로드맵 보기] | [report:6 등록된 전체 Ticket 보기] | [/query?status=new&status=assigned&status=reopened&status=closed&version=0.0.1&order=priority 0.0.1 전체 Ticket 보기]
 * 최신 소스 보기
  * SVN: [/browser/trunk browser/trunk], SVN Check Out URL: http://localhost/svn/%PROJECT_NAME%/trunk/,
  * GIT: [/browser/git browser/git], GIT Clone URL: http://localhost/git/%PROJECT_NAME%/
 * 문서: [wiki:ProjectSpec 프로젝트 정보] | [wiki:DevSpec 개발 사양서] | [wiki:MaintenanceHistory 유지보수 일지]
 * 가이드라인: [wiki:CodingGuideline 코딩] | [wiki:ReleaseGuideline 릴리즈] | [wiki:TicketGuideline 티켓] | [wiki:MeetingNoteGuideline 회의록] | [wiki:CodeReivewGuideline 코드리뷰]
 * 개인별 WIKI: [wiki:WikiHong 홍길동] | [wiki:WikiCSKim 김철수]

= 5. 참고사항 =
 * 매뉴얼: [wiki:BlueCIManual Blue CI] | [wiki:JenkinsManual Jenkins] | [wiki:NexusManual Nexus] | [wiki:SonarManual Sonar] | [wiki:MavenManual Maven] | [wiki:EclipseManual Eclipse]
 * 링크1: http://blueci.bluedigm.com
 * 링크2: http://blueci.bluedigm.com
 * Trac 활용 참고 사이트(TextCube): [http://dev.textcube.org/wiki]
'
WHERE name = 'WikiStart';


INSERT INTO wiki VALUES('MyTickets',1,1350806306263000,'admin','127.0.0.1','[[PageOutline]]
{{{
#!div style="float:left; margin-right:1em; width:30%"

= 대기: [[TicketQuery(status=new|assigned|reopened,milestone=0.0.1,format=count)]] 건 =

[[TicketQuery(group=priority,status=new|assigned|reopened,milestone=0.0.1)]]

}}}
{{{
#!div style="float:left; margin-right:1em; width:30%" 

= 진행: [[TicketQuery(status=accepted|reviewing,milestone=0.0.1,format=count)]] 건 =

== 시작됨 ==

[[TicketQuery(status=accepted,order=priority,milestone=0.0.1)]]

== 검토중 == 

[[TicketQuery(status=reviewing,milestone=0.0.1)]]

}}}
{{{
#!div style="float:left; margin-right:1em; width:30%" 


= 완료 [[TicketQuery(status=closed,milestone=0.0.1,format=count)]] 건 / [[TicketQuery(milestone=0.0.1,format=count)]] 건(전체) = 

== 일반: [[TicketQuery(status=closed,milestone=0.0.1,resolution=fixed,format=count)]] 건 ==

[[TicketQuery(status=closed,group=type,resolution=fixed,milestone=0.0.1)]]

== 기타: [[TicketQuery(status=closed,milestone=0.0.1,resolution!=fixed,format=count)]] 건 ==

[[TicketQuery(status=closed,group=resolution,resolution!=fixed,milestone=0.0.1)]]


}}}

{{{
#!div style="clear:both"
}}}

=== [/report 이용 가능한 리포트] ===
=== [/query 맞춤형 질의] ===
= 나와 관련된 티켓 =

== 내가 작업할 티켓 (My ticket) ==
[[TicketQuery(owner=$USER&status!=closed,table)]]

== 내가 참고할 티켓 (CC to me) ==
[[TicketQuery(cc=~$USER&status!=closed,table)]]

== 내가 등록한 티켓 (Report by me) ==
[[TicketQuery(reporter=$USER&status!=closed,table)]]
', NULL, NULL);


INSERT INTO wiki VALUES('BlueCIManual',1,1350806306263000,'admin','127.0.0.1','[[PageOutline]]
= 1. 개요 =
PM이 프로젝트를 효율적으로 진행하려면 산출물을 잘 관리하여 의사소통의 비용을 최소화 하여야 합니다.

특히 이슈(문제점, 개선사항 요청 등)를 관리하는 전통적인 방식인 엑셀 파일관리나 웹 게시판 등의 방법은 이슈의 라이프사이클 제대로 제공하지 못하며, 결국 경험의 축적이 자산화로 연결되지 못합니다.

프로젝트의 이슈는 프로젝트에서 정의한 이슈 작업흐름(work flow)에 따라 생성에서 종료까지가 이슈의 상태기반으로 담당자와 작업이 유기적으로 연결되어야 하며,

그 과정이 투명하게 보여야 하고, 이력(history)으로 남겨질 수 있어야 하겠습니다.

개발자의 경우 프로그램을 작성 만하면 시스템이 자동적으로 빌드 및 품질 보고서를 제공하여 고품질의 빠른 결과물 배포가 가능하게 됩니다.

Blue CI 는 다음과 같은 이점을 제공합니다.

 * 프로젝트 이슈의 투명성
 * 공동작업에 효율성 증진
 * 지식축적
 * 소스연동을 통한 접근성 강화
 * 자동 빌드 관리
 * 품질 관리
[[Image(blueci_structure.png)]]
= 2. 설치 및 실행 =
== 2.1 Clean 설치 ==
 * 주의사항: 설치 후 반드시 /home/blueci/bin/license.txt 파일을 읽은 다음 사용하시기 바랍니다.
 * blueci 계정으로 로그인합니다. 사용자가 없는 경우 adduser blueci 로 추가
 * 설치 관리자를 실행합니다.
{{{#!sh
  [/home/blueci]$ source blueci_installer.sh
}}}
 * Auto Clean Install 에 있는 All-In-One 설치를 위해 1번을 입력한 다음 [Enter]
  - 참고: Manual Clean Install 에서 설치하려는 버전을 직접 입력하여 설치 할 경우 설치가 실패할 수 있고 테스트 되지 않는 버전에 대해서 정상적인 동작을 보장할 수 없음 
  - 의존성 패키지 설치를 위해 root 비밀번호 입력이 요청됩니다.
 * startup.sh 명령어로 Blue CI 서버를 구동합니다.
{{{#!sh
  [blueci]$ startup.sh
}}}
 * Blue CI에 접속해 봅니다.
  - 프로젝트 관리 구성만 설치한 경우(Trac): http://<server ip>/trac
  - 빌드 관리 구성까지 설치한 경우(Jenkins, Sonar, Nexus): http://<server ip>/jenkins or sonar or nexus
 * 서버 정지
{{{#!sh
  [blueci]$ shutdown.sh
}}}
 * 프로젝트 추가: ex) add-project test-prj simple
{{{#!sh
  [blueci]$ add-project.sh <프로젝트이름> <테마이름(옵션)>
}}}
 * 프로젝트 템플릿위치: /home/blueci/template/trac/trac-update-default.sql 또는 trac-update-[테마명].sql
 * 설치 위치
  - Trac -> /home/blueci/repository/trac-repo/<프로젝트이름>
  - Git -> /home/blueci/repository/git-repo/<프로젝트이름>
  - Subversion -> /home/blueci/repository/svn-repo/<프로젝트이름>
 * 다른 Blue CI 서버에 적용하는 법 : /home/blueci/repository/trac-repo | git-repo | svn-repo/<프로젝트명> 을 동일한 위치에 복사합니다.

  동기화: trac-admin-sh.sh <프로젝트명> resync

= 3. Blue CI 패키징 구성 =
== 3.1 CI 환경 서버 ==
 Apache, PHP, Drupal, Subversion, Git, Python, Trac, JDK, Tomcat, Jenkins, Sonar, Nexus, Maven
== 3.2 개발자 개발 환경 ==
 JDK, Maven, Eclipse

= 4. 버전 정보 =
== Blue CI 		1.0	(released 2013-10-01) ==
 * Apache		2.2.25	(released 2013-07-09) -> apps/apache
 * PHP			5.5.4	(released 2013-07-05) -> apps/php
 * Drupal		7.23	(released 2013-08-08) -> apps/apache/htdocs
 * Subversion		1.8.3	(released 2013-08-30) -> apps/svn
 * Git			1.8.4	(released 2013-08-23) -> apps/git
 * Python		2.7.5	(released 2012-05-15) -> apps/python
 * Trac			1.0.1	(released 2013-02-01) -> apps/python/Lib/site-packages/trac-1.0.1-py2.7.egg

 * Java SE 7		1.7.0_40(released 2013-09-10) -> jdk7
 * Tomcat		7.0.42	(released 2013-07-05) -> apps/tomcat
 * Jenkins		1.531	(released 2013-09-16) -> apps/jenkins, apps/tomcat/webapps/jenkins
 * Sonar		3.7	(released 2013-08-14) -> apps/sonar, apps/tomcat/webapps/sonar
 * Nexus		2.6.3 	(released 2013-09-16) -> apps/nexus, apps/tomcat/webapps/nexus
 * Maven		3.1.0	(released 2013-07-15) -> apps/maven
 
 * Eclipse		4.3	(released 2013-06-26) -> apps/eclipse

= 5. 세부 패키징 구성 =
== 5.1 Trac plug-in ==
 * Babel	0.9.6
 * Docutils	0.11
 * Genshi	0.7
 * Pygments	1.6
 * pytz	2013d
 * RPC	1.1.2
 * setuptools	0.9.8

 * AdvancedTicketWorkflowPlugin	0.11dev
 * ExcelDownloadPlugin	0.12.0.3
 * IniAdmin	0.3
 * NavAdd	0.3
 * PageToHtml	0.1
 * PrivateWikis	1.0.0
 * TicketCalendarPlugin	0.12.0.2
 * timingandestimationplugin	1.3.7
 * TracAccountManager	0.5dev
 * TracAutoWikify	0.2dev
 * TracCustomFieldAdmin	0.2.8
 * TracDateField	3.0.0dev
 * TracDiscussion	0.8
 * TracDragDrop	0.12.0.11
 * TracGanttCalendarPlugin	0.6.2
 * TracNavControl	1.0
 * TracSQL	0.3
 * TracSVNAuthz	0.11.1.1
 * TracTags	0.7dev
 * TracTocMacro	11.0.0.3
 * TracWysiwyg	0.12.0.5
 * TracXMLRPC	1.1.2
 * WorkflowEditorPlugin	1.2.0dev

= 6. 암호화 =
== 6.1 Trac ==
 - 관리자 계정: 기본값 admin/qmffn123 (블루123)
 - 관리 > 권한 > anonymous 권한을 모두 체크하고 하단의 [선택한 아이템 삭제하기] 버튼을 클릭한다.

== 6.2 Jenkins ==
 - 우측상단의 [가입]에서 관리자 계정을 추가한다.
 - Jenkins 관리 > Configure System > Enable security 체크 > Access Control > Security Realm > Jenkins own user database 선택 > 저장한다.
 - Jenkins 관리 > Configure System > Access Control > Authorization > Matrix-based security 선택 > User/group to add: admin ID 추가 후 Overall > Administer 권한을 체크한다.
 - 익명 접근을 제한하려면 Anonymous > 모든 권한 해제
 - build 내역을 trac의 시간이력에 표시하려면 Anonymous 또는 특정 사용자를 추가한 한다음 Overall > Read권한을 추가한다. (trac용 hudson plugin 설치 필요)

== 6.3 Nexus ==
 - 관리자 계정: 기본값 admin/admin123
 - Security > Users > admin 우측 버튼 > Set Password
 - 익명 접근이 가능한 것을 막으려면 Administration > Server > Security Settings > Anonymous Access 체크를 해제한다.

== 6.4 Sonar ==
 - sonar 관리자 암호를 변경한다. (admin/admin)
 - Settings > Security > Users > Change password > 새로운 암호 입력 후 Update
 - Settings > Security > Global Permissions > Execute Analysis, Execute Local Analysis 에서 Anyone 제거 후 sonar-users 추가
 - Settings > General Settings > Security > Force user authentication > True > Save Security Settings

== 6.5 Drupal ==
 - drupal 관리자 암호를 변경한다. (admin/qmffn123)
 - 우측 상단 내계정 > 수정하기 > 비밀번호 수정
 
= 7. Blue CI template 사용 =
 * Subversion 프로젝트 생성 스크립트: add-svn.sh, 템플릿위치: /home/blueci/template/svn
 * Trac 기본 설정: /home/blueci/repository/trac.ini
 * Trac 프로젝트 별 설정 템플릿: /home/blueci/template/trac/trac.ini.tpl
 * Trac 로고 이미지: /home/blueci/template/trac/logo.png

= 8. Trac 플러그인 설치법 =
 * URL 설치: easy_install http://trac-hacks.org/svn/tracwysiwygplugin/0.12
 * 소스 설치: <plug-in 소스 위치>/python setup.py install
 * egg 설치: easy_install PrivateWikis-1.0.0-py2.6.egg
 * 웹 설치: 관리 > 일반 > 플러그인 > *.egg 파일 선택후 [설치하기] 클릭
 * trac 플러그인 설정

  trac.ini 직접 수정: /home/blueci/repository/trac-repo/<프로젝트명>/conf/trac.ini 수정
{{{
[components]
tracwysiwyg.* = enabled
}}}
  - Trac 프로젝트 생성 시 적용: 템플릿 수정 (/home/blueci/template/trac/trac.ini.tpl)
  - webadmin 설정: 관리 > 일반 > 플러그인 > 해당플러그인 > 활성화됨에 체크한 다음 [변경사항 적용하기] 클릭

= 9. 기타 참고사항 =
 * Wiki CamelCase 자동 링크 해제: 관리 > trac.ini > wiki > ignore_missing_pages 옵션 true 설정
 * Subversion Revision 삭제방법 (Blue CI Apache Server 종료 후 작업)
{{{#!sh
  [blueci]$ shutdown.sh apache
}}}
  - /home/blueci/repository/svn-repo/<프로젝트명>/db/current 파일을 열어 현재 리비젼을 롤백할 버젼으로 바꾼다.
  - /home/blueci/repository/svn-repo/<프로젝트명>/db/revs 에서 Revision 파일을 지운다. (이름 바꾸는 쪽을 추천)
  - /home/blueci/repository/svn-repo/<프로젝트명>/db/revprops 에서 Revision 파일을 지운다.
  - 동기화: trac-admin-sh.sh <프로젝트명> resync
', NULL, NULL);


INSERT INTO wiki VALUES('MeetingNote20130701',1,1350806306263000,'admin','127.0.0.1','= Project Kickoff 회의 =

= 주제 =
 1. 프로젝트 관련사람들이 모두 모여 프로젝트 내용을 공유한다.

= 기본 사항 =
 * 장소: 대회의실
 * 시간: 2013-07-01 10:30 ~ 12:00
 * 작성자: 홍길동 사원

= 참석자 =
 * 고객: 김철수 부장
 * 개발사: 홍길동(PM)

= 협의 사항 =
 1. 내용
 1. 내용

= 회의 내용 =
 1. 내용
 1. 내용

= 다음 회의 =
 1. 내용
 1. 내용
', NULL, NULL);


INSERT INTO wiki VALUES('ReleaseNotes',1,1350806306263000,'admin','127.0.0.1','= Blue CI Release Notes =
 * http://blueci.bluedigm.com

== Changes in version 1.0 (2013-10-01) ==
 * Task
  - [BLUECI #1] 리눅스용 최초 릴리즈
', NULL, NULL);


INSERT INTO wiki VALUES('ProjectSpec',1,1350806306263000,'admin','127.0.0.1','= 1. 주요 공유사항 =
== 1.1 담당자 ==
 1. 운영서버 관리자: 홍길동 사원 | 010-1234-1234 | kildong.hong@bluedigm.com
 1. 운영DB 관리자:

== 1.2 계정정보 ==
|| 사용자 || 이름 || 그룹 || 권한 || 설명 ||
|| admin || 홍길동 || administrator || 모든권한 || 최고 관리자, 초기암호(admin) ||
|| hong || PM || administrator || 모든권한 || hong 프로젝트 최고 관리자, 티켓 관리 ||
|| leader || 개발자1 || developer || 개발 관리자에 필요한 모든권한 || 개발자 그룹, 티켓 관리 ||
|| harry || 검토자1 || developer || 테스트에 필요한 모든권한 || 테스터 ||
|| sarry || 개발자2 || developer || 개발에 필요한 모든권한 || 개발 ||
|| john || 참관자1 || observer || 필요한 메뉴들 읽기 권한 || 참관자 그룹 ||
|| downloader || 다운로드 || - || 다운로드 || 배포판을 다운로드만 할 수 있는 권한 ||
|| vendor || 외주 || vendor ||위키 읽기, 티켓등록, 수정, || 외주사 계정(옵션) ||
|| guest || 손님 || - || 특정 메뉴 읽기 || 손님 그룹 ||
|| anonymous || 외부손님 || - || 권한없음 또는 위키 읽기권한 || 계정이 없는 외부 손님 ||

== 1.3 코드 ==
 1. 사용자: 1-관리자, 2-일반

= 2. 서버정보 =
== 2.1 운영 서버 ==
 * 모델: IBM X3650 M3
 * 자원: 2 CPU, 8G RAM, 300G * 2 (raid-1미러링)
 * 네트워크: IP-192.168.1.5, Subnet-255.255.255.0, GW-192.168.1.1, DNS-192.168.1.2
 * OS: Windows 2008 Standard Edition X64
 * JVM: 1.6.0_23 (옵션: -Xms256m -Xmx1024m -Xss12m)

== 2.2 운영 웹서버 ==
 * 버전: Tomcat 7.0.32
 * 관리페이지: http://192.168.1.6:8080/manager
 * 계정: admin / admin
 * 설치 위치: /home/blueci/apps/tomcat
 * 로그 위치: /home/blueci/apps/tomcat/logs

== 2.3 운영 DB ==
 * 버전: MySQL 5.1.50 x64
 * URL: jdbc:mysql://192.168.100.6:3306/blueci
 * Class Name: com.mysql.jdbc.Driver
 * 계정: userid/passwd

== 2.4 개발 서버 ==
== 2.5 개발 웹서버 ==
== 2.6 개발 DB ==
', NULL, NULL);


INSERT INTO wiki VALUES('DevSpec',1,1350806306263000,'admin','127.0.0.1','[[PageOutline(1-3,목차)]]

= 1. 게시판 =
 * 검색: 이름, 제목으로 검색한다.

= 2. 관리자 =
== 2.1 사용자 ==
 1. 추가
   * 사용자 아이디, 이름, 비밀번호를 입력하여 사용자를 추가한다.
', NULL, NULL);


INSERT INTO wiki VALUES('MaintenanceHistory',1,1350806306263000,'admin','127.0.0.1','= 유지보수 일지 =
== Works  in version 2 (2012-10-25) ==
 * 서버 이전 전화 조치
   * IP 변경: 192.168.1.6 -> 192.168.1.7

== Works  in version 1 (2012-10-24) ==
 * 제품 설치를 위한 사업장 방문
   * OS: Redhat Linux 설치
   * DB: Mysql 설치
', NULL, NULL);


INSERT INTO wiki VALUES('ReleaseGuideline',1,1350806306263000,'admin','127.0.0.1','= 1. Release 버전 =
 1. exe 인스톨러로 릴리즈 되는 정식 버전 형식은 <major>.<minor>.<release counter>이며, 해당 버전의 소스는 tag로 보관됩니다. ex) 4.0.0
 1. jar, war 를 패치한 버전은 jar, war 내에있는 META-INF\MANIFEST.MF 파일의 버전 표시에 기록 되며, <major>.<minor>.<release counter>.<patch counter> 형식입니다. ex) 4.0.0.p1

= 2. Release Notes 코드 =
 1. BLUECI(Blue CI), 전체 코드 예 : (BLUECI !#4)
 1. 티켓 종류 (Ticket Types)
   * 문제점 (Bug): 현재 제공되고 있는 기능에 대한 버그 수정 작업
   * 개선사항 (Improvement): 현재 제공되고 있는 기능에 대한 개선 작업
   * 새 기능 (New Feature): 현재 제공하지 않는 기능 추가 작업
   * 해야할 일 (Task): 기타 프로젝트를 위해 수행되어야 하는 작업
 1. # Trac ticket number
', NULL, NULL);


INSERT INTO wiki VALUES('TicketGuideline',1,1350806306263000,'admin','127.0.0.1','= 1. Ticket 구성요소 =
== 1.1 중요도 (priorities) ==
 1. 매우 심각한(blocker): 해결되지 않으면 더 이상의 업무진행이 불가. Show Stopper 라고도 부른다.
 1. 심각한 (critical): 금전관계나 무결성 훼손, 심각한 오류로 인한 고객 상실 야기의 수준. 제품의 핵심기능과 관련됨
 1. 중요한 (major): critical 을 제외한 설계상의 오류나 기능의 실패. SW 의 주요 업무 진행에 관련
 1. 사소한 (minor): 주 업무 진행에 관여되진 않았지만, 고객이나 사용자의 불만이 될 수 있는 오류. 혹은 사용을 편리하게 만들어 주는 추가 기능
 1. 매우 사소한 (trivial): 사소한 오타나, 눈에 잘 띄지 않는 오류. 우선 순위가 상당히 낮은 기능 요구 사항

== 1.2 모듈 구성(component) ==
프로젝트를 나누는 단위(유즈케이스, 업무파트 단위 등등) 말그대로 기능의 분류이다. 이 Trac의 컴포넌트는 Wiki, Roadmap, Timeline, ticket System, Report System, general 등으로 되어 있다.

== 1.3 마일 스톤(milestone) ==
정식버전에 이르기까지 필요한 요구사항을 충족하는 각각의 단계 예: 0.1, 1.1.2, alpha, beta, RC(release candidate), RTM, M1(Milestone 1)

 * 마일스톤은 시간의 이정표이다. 버전과는 약간 다른 시간적 개념이라 볼 수 있다. (보통 3개월 이상)
 * 마일스톤에 시간설정면 남은 기간이 표시되므로 세부 일정을 관리할 수 있다.
 * 마일스톤 상에서 해야할 일들은 ticket으로 나타난다. 완료된 ticket이 많을 수록 마일스톤의 진행도가 높아진다.
 * 마일스톤이 완료되면 PL이 완료되었음을 설정하고, 모든 마일스톤이 완료되면 정식 배포 버전을 생성하여 배포한다.

== 1.4 버전(version) ==
정식 배포 버전: [wiki:ReleaseGuideline 릴리즈 가이드라인 참고]

== 1.5 Ticket 타입별 마일 스톤 및 버전 선택 요령 ==
 * 문제점 (Bug): 이미 릴리즈 된 정식 버전에 해당하므로 미래에 해당하는 milestone은 선택하지 않습니다.
 * 개선사항 (Improvement): 개선할 점이 반영되기를 원하는 차기 milestone을 선택해 주시고, 개선할 점이 확인된 version을 선택해 주세요.
 * 새 기능 (New Feature): 새 기능이 반영되기를 원하는 차기 milestone을 선택해 주세요.
 * 해야할 일 (Task): 할일에 해당되는 milestone 이나 version 이 있으면 선택해 주세요.

== 1.6 해결종류(Resolution) ==
 * Fixed: 문제가 고쳐짐, 수정됨
 * Invalid: 유효하지 않음, 데이터가 불충분함
 * Wontfix: 고칠 필요 없음
 * Duplicate: 다른 티켓과 중복됨, 이미 보고된 문제임
 * WorksForMe: 여기서는 발생하지 않음, 재현 불가능

== 1.7 티켓 업무흐름도 ==
 * new: 티켓이 새롭게 생성됨
 * assigned: 티켓을 처리할 담당자가 지정됨
 * accepted: 티켓을 처리할 담당자에 의해 접수됨
 * reviewing: 티켓을 검토할 담당자에 의해 접수됨
 * closed: 티켓이 처리됨
 * reopened: 처리된 티켓이 다시 열림

[[Image(visual-workflow.png)]]

= 2. 프로젝트 참여 인원 생성 =
 * 운영자: Trac, Drupal, Jenkins, Sonar, Nexus 시스템을 관리한다.
 * 개발자: 프로그램을 개발한다.
 * 테스터: 프로그램을 테스트한다.

= 3. 프로젝트 진행 =
 1. 프로젝트가 결정되면 팀이 함께 모여 회의를 진행한다.
 1. 회의록을 작성하고 주요 공유사항은 wiki를 활용하여 공지한다.
 1. 전체 계획(정식 배포 버전 1.0.0)을 중기 계획으로 나누어, 마일스톤(0.0.1, 0.0.2 혹은 코드네임 등)으로 지정한다.
 1. 마일스톤(중기계획)을 세부 계획으로 나누어 PL에게 Ticket을 assign 한다.
 1. 각 Ticket에 대한 내용을 팀원들끼리 토의하여 PL로 부터 Ticket을 accepted 하여 개발을 진행한다.
 1. 개발을 진행하면서 발생되는 개선사항, 새 기능, 해야할 일이 생기면 wiki에 메모해 놓는다.
 1. 세부 계획들이 완료되면, 최초 마일스톤의 테스트를 진행한다.
 1. 테스트가 완료되면 테스트 결과와 개발중에 메모했던 내용으로 회의를 진행하고 시간과 기능을 조율한다.
 1. 모든 마일스톤이 완료되면 최종 버전을 배포한다.
', NULL, NULL);


INSERT INTO wiki VALUES('MeetingNoteGuideline',1,1350806306263000,'admin','127.0.0.1','= 회의 이름 =

= 주제 =
 1. 주제
 1. 주제

= 기본 사항 =
 * 장소: 대회의실
 * 시간: 2012-10-25 10:30 ~ 12:00
 * 작성자: 홍길동 사원

= 참석자 =
 * 고객: 김철수 부장

= 협의 사항 =
 1. 내용
 1. 내용

= 회의 내용 =
 1. 내용
 1. 내용

= 다음 회의 =
 1. 내용
 1. 내용
', NULL, NULL);


INSERT INTO wiki VALUES('WikiHong',1,1350806306263000,'admin','127.0.0.1','= 1. 개인 TODO 리스트 =
 * (~11/31) 개발환경 구축
 * (~11/10) 자료 분석

= 2. 참고자료 =
 * 링크1: http://blueci.bluedigm.com
', NULL, NULL);


INSERT INTO wiki VALUES('CodingGuideline',1,1350806306263000,'admin','127.0.0.1','[[PageOutline(1-3,목차)]]

= 1. Code Conventions =
== 1.1 기본사항 ==
 1. Font (글꼴)
   * 굴림, 10pt
 1. Line Length (줄 길이)
   * 120
 1. Indent (들여쓰기)
   * 4space의 크기를 가지는 Tab 사용
 1. Wrapping (줄바꿈)
   * Line Length를 넘어서 Wrapping을 해야 할 경우에는 콤마(,) 바로 뒤나 연산자(+, -, *, / 등)바로 앞에서 이루어 진다.
   * Wrapping은 3. Indent의 기준을 지키는 것을 원칙으로 하나, 의미적으로 연결되는 위치까지 Wrapping되어도 된다.
{{{
if(variable1 == variable2 
	|| variable3 == variable4)
System.out.println("This Example is Wrapping"
	+ variable1 + variable2);
}}}
 1. Space (공백)
   * 구분자(콤마",", 세미콜론";") 뒤에는 스페이스를 가진다.
   * 명령문(for, if, if~else, switch, while, 등등) 뒤에는 스페이스를 가지지 않는다.
   * 점(.)을 제외한 binary operator 앞뒤에는 스페이스를 가진다.
   * 연산자 앞 뒤에 스페이스를 가진다.
 1. Brace (괄호)
   * Brace는 한 줄로 표시를 한다. 즉, Brace 시작과 끝 표시를 한 줄에 할당하여 표시한다. 이것은 구분을 편히 해 주기 위해서 이다.
   * Brace문 안에 단문일 경우에는 brace를 생략해도 무방하다. 하지만 한 줄로 이루어진 복문일 경우에는 brace를 생략해선 안 된다.
{{{
for(int i = 0; i < variable1; i++)
{
…………
}

while(……)
{
    if(……)
    {	
    }
}

if(……)
    return;
}}}
 1. variable 선언
   * 변수 선언은 한 변수에 하나의 변수 값만을 선언해야 한다.
   * 같은 형식의 변수도 따로 분리하여 선언해야 한다.
{{{
// 잘된 선언
int variable1 = 1;
int variable2 = 2;
int variable3 = 3;

// 잘못된 선언
int variable1 = variable2 = variable3 = 1; ? (×)
int variable1 = 3, variable2 = 4, variable3 = 5; ? (×)
}}}
 1. package, import 선언
   * Java 파일 시작에서 그 Java 파일의 정보 선언(파일 명, Copyright 등)뒤에 선언되어야 한다.
   * import 선언은 클래스 이름을 명기 해야 한다. 이것은 연관 클래스의 명확한 이해를 위해서 아스타(*)를 선언해서는 안되고, 확실한 이름을 명기 해야 한다.
{{{
// 잘못된 명기
import java.io.*;
}}}
 1. 기타
   * 값이 boolean일 경우 비교 연산자(==)를 사용하지 않는다.
{{{
if (foo)

// 잘못된 사용
if (foo==true)
}}}
   * 반복문 안에서 로깅을 할 경우 성능 향상을 위해 isDebugEnabled() 와 같은 레벨에 맞은 로깅여부를 확인하도록 한다.
{{{
for()
{
	if (logger.isDebugEnabled())
	{
		logger.debug("debug");
	}
}
}}}

== 1.2 Comment (주석) ==
  프로그램을 작성할 때는 항상 Comment를 정성을 다해서 달아주어야 한다. 이것은 자신만이 알고 있는 사항을 다른 사람이 알려주는 역할을 하게 될 뿐만 아니라 차후에 자신이 유지보수 할 때도 유용하게 사용될 수 있기 때문이다. Comment는 충분히 이해 할 수 있게 작성이 되어져야 할 것이다.  클래스와 메소드 Comment는 매뉴얼에 사용되기 때문에 HTML 형식을 갖추어서 작성하고 상세히 적는다.

 1. Block Comment (블록 주석)
   * Comment의 시작은 "/**"로 시작을 하고, 종료는 "*/"으로 종료한다.
   * 각 라인의 시작은 "*"로 시작을 한다.
   * Comment의 시작 첫줄은 "/**"이것 이외 다른 것을 삽입할 수 없다.
 1. Line Comment (라인 주석)
   * Comment의 시작은 "//"로 시작한다. 종료는 아무것도 표시하지 않는다.
   * Comment의 기본은 라인의 옆에 위치하지만 줄 길이가 120이 넘으면, Comment를 달 라인 바로 위에 위치해야 한다.
 1. File Comment (파일 주석)
   * 파일 시작에 위치하는 Comment는 지금 만들고자 하는 Java 파일의 파일 명과 라이센스 정보가 들어가게 된다.
 1. Class Comment (클래스 주석)
   * 클래스의 정보 설명은 클래스를 선언 하기 전에 Comment를 달아주게 된다. 형식은 HTML 형식에 맞추어준다.
   * 또한 클래스의 정보 설명이 있고 난 후에는 반드시, 저작자 명, 버전은 항상 들어가야 된다.
   * 그리고 Version은 버전을 쓰고, 년(YYYY)-월(MM)-일(DD)식으로 구성된다.
 1. Java Custom Tag
   * 자바만이 사용하는 custom tag가 있다. 이를 통하여 상세한 정보를 보여줄 수 있다.
   * custom tag에서 tag와 변수 그리고 설명 사이에는 tab을 사용하여 분리한다.
   * 다음은 자바에서 사용 가능한 custom tag와 각각이 지니는 의미이다.
     * @author : Source의 저자를 명시하기 위한 tag
     * @version : 프로그램의 version을 명시하기 위한 tag (해당하는 값으로 version과 년-월-일을 조합해서 나타냄)
     * @param : Method의 parameter를 나타내기 위한 tag.
     * @return : Method의 return값을 나타내기 위한 tag.
     * @exception : Method에서 발생할 수 있는 exception을 명시하기 위한 tag
     * @see : 참조하기위한 Class나 Interface를 명시하기 위한 tag
     * @since : Jdk version 얼마이후부터 유효한 Class나 Method인지 명시하기 위한 tag.
     * @deprecated : Jdk version 얼마이후부터 사용하지 않는 Class나 Method인지 명시하기 위한 tag.
 1. Method Comment (함수 주석)
   * 메소드의 정보 설명은 메소드를 선언 하기 전에 Comment를 달아준다.
   * 메소드의 역할, 설명이나 예시는 HTML 형식으로 자세히 적어준다.
   * parameter, return, exception이 존재하면 자세히 입력한다.
   * 추가된 메소드가 맨처음 만든 사람과 다를 경우에는 author를 넣어준다.
   * 예시가 있을 경우에는 예시도 작성해 주어야 한다.

== 1.3 Naming ==
  Naming Convention은 다른 개발자에게 자바코드의 이해를 돕고자 하는 것이므로, 완벽하게 Naming 규약을 지켜야 한다. 프로그램을 하는 중에는 이것을 지키는 것이 매우 귀찮을 때가 많다. 예를 들어 int형이 long형으로 바뀌게 되면, 거기에 해당하는 변수의 이름이 바뀌게 되어 있다. 이것 모두를 바꾼다는 것이 귀찮을 수 있다. 하지만, 나중에 유지 보수 차원이나 인수 인계등의 다른 사용자가 본다는 것을 감안하여 Naming Convention을 따라 주어야 한다.

 1. File Name (파일 이름)
   * JSP
{{{
- 등록 폼 : AddPointForm.jsp
- 수정 파일 폼 : EditPointForm.jsp
- 뷰 파일 : ViewPoint.jsp
- 목록 파일 : ListPoints.jsp
- 조회 파일 : SearchPoints.jsp
- Include File : <%@ include file="IncludeTop.jsp" %>
}}}
 1. Class Name (클래스 이름)
   * Class 이름은 첫 글자는 항상 대문자로 시작한다.
   * 단어의 조합으로 이루어진 이름은 단어 첫 글자가 대문자로 구성되어 져야 한다.
   * 일반적인 약어는 사용할 수 있으나, 그 외의 약어는 절대 사용할 수가 없다.
   * Sun Java Convention에 나오는 약어는 반드시 약어로만 사용하여야 한다.
   * Beans 클래스 : 파일 이름 뒤에 Beans를 붙여준다.
   * Servlet 클래스 : 파일 이름 뒤에 Servlet를 붙여준다.
   * Unit Test 클래스 : 파일 이름 뒤에 Test를 붙여준다.
{{{
// Doc -> Document 가능
public class DocDrawTest extends Applet
// Temp -> Temporary 가능
public class TempFrameDrawTest extends Applet
// Beans 클래스
public class ClassNameBeans
// Servlet 클래스
public class ClassNameServlet extends HttpServlet

// 잘못된 이름
public class ConvMessage -> ConvertMessage로 표기
public class InitializeFrame -> InitFrame로 표기
}}}
 1. Interface & Abstract ClassName (인터페이스와 추상 클래스 이름)
   * Class중 인터페이스와 추상 클래스 파일을 열지 않고도 쉽게 식별할 수 있도록 한다.
   * 인터페이스 : 파일 이름 앞에 대문자 I를 붙여준다.
   * 추상 클래스 : 파일 이름 앞에 Abstract를 붙여준다.
{{{
// 인터페이스 이름
public interface IClassName 
// 추상 클래스 이름
public abstract class AbstractClassName 
}}}
 1. Method Name (함수 이름)
   * 메소드 이름은 메소드의 기능을 내포한 이름이 되어야 한다.
   * 첫 글자는 소문자로 시작한다.
   * 단어로 조합을 해서 작성된다면, 첫 단어를 제외하고는 단어 첫 글자는 대문자로 시작해야 한다.
   * 동사로 시작하는 것을 권장한다. (권장 단어 : get, set, draw, calc, convert, is, ...)
{{{
public int getDelta()
private void setDelta(int p_nDelta)

// 잘못된 이름
private void putDelta(int p_nDelta)
}}}
 1. Variable Name (변수 이름)
   * 길이 제한 없이, Variable이 어떤 의미를 가지는지를 충분히 이해 할 수 있는 단어를 사용한다.
   * 각 변수의 값중 배열일 경우에는 변수 뒤에 ‘s(소문자)’를 붙여주어 배열임을 표시한다.
{{{
// 배열 변수
String[] sStrings = new String[2];
int[] nCounts = new int[10];
}}}
 1. Global(member) Variable (멤버 변수)
   * “m_”로 시작하고 바로 뒤에 변수 형을 소문자로 적는다.
   * 변수 이름을 대문자로 시작하여 적는다.
   * 변수 우측에 Comment를 적어 주어야 한다.
   * 형식 : m_ + [변수 형] + [변수 이름]
   * 상수는 형식을 따르지 않고 대문자로만 사용한다.
{{{
public class DrawTest extends Applet
{
	// 1. Primitive Type인 경우 	
	int     m_nInstanceCount;	// Instance 갯수
	boolean m_bIsInstance;		// Instance 인지 여부
	char    m_chToken;		// 구분자
	byte    m_byteTokenString;	// 구분 문자열
	short   m_shortFrameCount;	// 프레임 갯수
	long    m_lDelta;		// 편차 저장
	float   m_fExtDelta;		// 세밀한 편차
	double  m_dSumDelta;		//  편차 합 
	
	// 2. Primitive Type은 아니지만 자주 쓰이는 경우
	String	m_sInstanceName;	// Instance 이름
	Vector	m_vInstance;		// …
	StringBuilder	sb
	HashMap		h
	Properties	p
	Enumeration	e
	
	// 3. 그래픽 관련 object Type인 경우
	Graphic	m_xGraphic;
	// 4. 그래픽 관련 object Type인 경우 	
	UserClass	m_oUc;		// 사용자 정의 Class
	// 5. 상수인 경우
	static final int NUMBER = 1;
}
}}}
 1. Local Variable (지역 변수)
   * 시작을 “m_”를 사용하지 않고, 형식은 Global Variable과 같다.
   * 중요한 변수에만 Comment를 달아준다.
   * 일반 loop에는 I,j,k 변수를 사용한다.
   * 형식 : [변수 형] + [변수 이름]
{{{
void DrawTextArea()
{
	int	nInstanceCount;  // Instance 갯수
	boolean	bIsInstance;
}

for(int i=0;i<10;i++)
{
	for(int j=0;j<10;j++)
	{
		...
	}
}
}}}

== 1.4 예외 상황 처리 ==
  자바 프로그램을 하다 보면, 예외 상황이 많이 발생한다. 이럴 경우 예외 상황에 대해서 적합한 처리를 하지 않는 경우에는 코드 자체가 느려지게 된다. 이런 상황을 방지하기 위해서 다음과 같은 사항을 고려해야 할 것 이다.

 1. 검사용 사용 금지
   * 예외 상황 처리를 단순한 검사를 하는 형태로 하는 방식은 속도 자체의 저하를 가져온다. 예를 들어서 설명하면 다음과 같다.
{{{
방법 1.
if(!s.empty()) s.pop();

방법 2
try
{
	s.pop();
}
catch(EmptyStackException e)
{
	code.
}
}}}
  위와 같은 상황에서 2가지 처리를 할 수 있다. 그러나 방법 1의 경우가 방법 2보다 2배 정도가 빠르다. 즉, 예외 처리를 검사를 대신하여 사용하지 않고 실제로 발생된 예외를 처리를 하는데 사용해야 한다.
 1. 세세한 조작 금지
   * 예외 상황을 너무 세세히 조작하지 않도록 한다.
  하나의 연계되어진 프로세스에 대해서는 각각 예외 처리를 따로따로 하여 너무 세분화를 하지 않도록 한다. 대신 하나로 예외처리를 해주면서, 각각에 대하여 주석 처리를 해서 분류를 하는 방식을 선택하도록 한다. 다음은 예이다.
{{{
// 방법 1.
try
{
	n = s.pop();
}
catch(EmptyStackException s)
{
}
try
{
	out.writeInt(n);
}
catch(IOException e)
{
}

방법 2.
try
{
	n = s.pop();
	out.writeInt(n);
}
catch(EmptyStackException s)
{
	// 스택이 비어 있는 경우
}
catch(IOException e)
{
	// 파일을 읽는 경우에 문제 발생
}
}}}
 1. 예외 상황 강제 진압 금지
   * 프로그래밍을 하다 보면, 상당히 많은 수의 예외 상황을 접하게 되는데, 이를 강제적으로 막아버리는 경우도 있다. 아래와 같이 처리하는 경우가 이에 해당한다. 아래와 같은 코드는 컴파일에서 시시콜콜 예외에 대하여 언급하지는 않을 것이다. 그러나, 중요한 예외 상황에 대하여 대처를 못하는 경우가 있음을 주의하고 가능하면, 이렇게 처리하는 것은 피하도록 해야 할 것이다.
{{{
try
{
	많은 코드들
}
catch(Exception e)
{
}
}}}
 1. 예외 상황 전파 대부분 프로그래머는 예외 상황을 감지하고 그곳에서 바로 처리 하려고 한다. 그러나 예외를 직접 감지하여 처리하는 대신 처리를 throws를 통하여 보다 높은 수준의 메소드에서 처리하는 방법도 있다.  이렇게 직접 예외를 처리하는 방법 보다 높은 수준 메소드에서 처리하는 것이 보다 정비된 처리를 할 수 있다는 점을 잊지 말고 이를 잘 활용하도록 하자.

== 1.5 샘플 파일 ==
{{{
/**
 * @(#)${file_name}
 * Copyright (C) 2005-2010 by Bluedigm Co., Ltd.
 * 
 * 4F., DeaKyeong B/D. 33-8, Nonhyun-dong, Gangnam-gu, Seoul,
 * South Korea, 135-815.
 * All rights reserved.
 *
 * This software contains confidential and proprietary intelligence asset of Namoo Co., Ltd.
 * You shall not disclose any Confidential Information provided herein and shall use
 * it only in accordance with the terms and conditions of the license agreement
 * you entered into with Namoo Co., Ltd.
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * Nothing in this notice shall be deemed to grant any rights to
 * trademarks, copyrights, patents, trade secrets or any other intellectual
 * property of the licensor or any contributor except as expressly stated
 * herein. No patent license is granted separate from the Software, for
 * code that you delete from the Software, or for combinations of the
 * Software with other software or hardware.
 */

package com.companyname.myproject.module;

import java.util.LinkedList;

/**
 * Base action that provides assistance commonly needed by action
 * 
 * <p><b>Other notes:</b>
 *
 * <p><b>WARNING:</b> Note that "<code>classpath*:</code>" when combined with
 * <ul>
 * <li>Implementing {@link org.springframework.core.io.Resource} to receive an init callback
 * </ul>
 *
 * @history
 *	2012. 10. 11	김철수	설명 추가 ………(자세한 내용)………………
 *	2012. 10. 14	홍길동	설명 추가 ………(자세한 내용)………………
 *	2012. 10. 20	김철수	설명 추가 ………(자세한 내용)………………
 *
 * @author 김철수 (admin@localhost)
 * @version 1.0, 2012. 10. 11
 * @see java.lang.ClassLoader#getResources(String)
 */
public class MyIntStack {
	
	/* Private Fields */
	private static final Log logger = LogFactory.getLog(PathMatchingResourcePatternResolver.class);
	
	/* Protected Fields */
	protected String name;

	/* Public Fields */
	public static final String PARAM_FINISH = "_finish";

	public MyIntStack(String name) {
		this.name = name;
		fStack = new LinkedList();
	}
	
	/* JavaBeans Properties */

	public int getOrderId() { return orderId; }
	public void setOrderId(int orderId) { this.orderId = orderId; }
  
	/* Public Methods */
  
	public final int getPageCount() {}

	public Item removeItemById(String itemId) {
		return (Item) obj;
	}
	/**
	 * Allocates a new <code>String</code> constructed from a subarray 
	 * of an array of 8-bit integer values. 
	 * <p>
	 * The <code>offset</code> argument is the index of the first byte 
	 * of the subarray, and the <code>count</code> argument specifies the 
	 * length of the subarray. 
	 * <p>
	 * @history
	 *		2012. 10. 11	김철수	변경된 내용 설명
	 *		2012. 10. 14	홍길동	변경된 내용 설명
	 *
	 * @author	Kwang-ho, Choi	(khchoi@bluedigm.com)
	 * @param	ascii     the bytes to be converted to characters
	 * @param	count     the length
	 * @return	String	  the value
	 * @throws IOException in case of I/O error
	 * @exception  IndexOutOfBoundsException  if the <code>offset</code>
	 *               or <code>count</code> argument is invalid.
	 * @deprecated This method does not properly convert bytes into 
	 * characters. As of JDK&nbsp;1.1
	 * @see        java.lang.String#String(byte[], int, int, String)
	 */

	/**
	 * 설명……………………………………………
	 *
	 * @param	ParameterName	파라메터 설명
	 */
	public int[] pop() {
		try {
			dfd
		}
		catch (HttpSessionRequiredException ex) {
			if (logger.isDebugEnabled()) {
				logger.debug(
						"Invalid submit detected: " + ex.getMessage());
			}
		}
		finally {
			con.close();
		}
		
		return ((Integer) fStack.removeFirst()).intValue();
	}

	public void createCompositeInterface(int p) {
		
		if (this.jndiObject != null) {
			// 라인 주석
			return "POST".equals(request.getMethod();  // 항목 주석
		}
		else if (!checkCommand(command) || getExpectedType() != null &&
				!getExpectedType().isInstance(this.defaultObject)) {
			throw new ServletExceptionthrow("Default object [" + this.defaultObject +
					"] is not of expected type [" + getExpectedType().getName() + "]");
		}
		else {
			return;
		}

		for (int i = 0; i < 10; i++) {
		}

 		// 2012. 10. 14 수정 by 홍길동
		while (resourceUrls.hasMoreElements()) {
		}

		switch (p) {
		case 0:
			fField.set(0);
			break;
		case 1: {
			break;
		}
		default:
			fField.reset();
		}
 		// 수정 끝
	}

	public boolean isEmpty() {
		return "POST".equals(request.getMethod();
	}

	protected Set doFindPathMatchingJarResources(String subPattern) throws IOException {
		JarFile jarFile = null;
		
		con.call(int arg1, int arg2,
						 int arg3, int arg4);
						 
		if (obj == this) {
			return true;
		}
	}
}
}}}
== 1.6 기타 사항 ==
 1. 커밋 로그에는 반드시 ticket 번호를 기술해야합니다. 예) (refs #1) 사용자 관리
 1. 클래스 설계 시 참고사항

자바의 기본은 클래스이다. 이것을 제대로 설계를 하는 것이 가장 기본이 될 것이다. 여기서는 클래스 설계 시에 항상 염두 해 두어야 할 사항을 기술 하고자 한다.

 * 메소드는 한 클래스의 인터페이스(프로토콜)를 분리시키는 간결하고 기능적인 단위로 설계하는 것이 좋다.
 * 다시 말해 메소드를 작성할 때는 간결하게 작성한다. 메소드의 코드 라인이 길면 여러 개의 짧은 메소드로 분리하는 방법을 찾아야 한다. 여러 개의 짧은 메소드로 만드는 일은 클래스 내부 코드에 대한 재사용성을 높인다.(때때로 메소드의 크기가 큰 경우가 있지만 대게 그런 경우는 메소드가 단지 하나의 작업만을 처리할 때가 많다.)
 * 생성자에는 객체를 적절한 상태로 설정하는데 필요한 코드만을 포함시키는 것이 좋다. 특히 다른 메소드의 호출을 피해야 하는데 그 이유는 호출될 메소드는 다른 프로그래머에 의해서 재정의 될 경우 객체가 생성되는 과정에서 기대하지 않은 결과가 나올 수 있기 때문이다. 또한 이 과정에서 클래스 변수들에 대하여 데이터를 초기화 하는 과정을 거쳐서 초기값 미지정으로 인한 문제를 미연에 방지하도록 한다.
 * abstract 클래스보다 interface를 많이 사용하는 것이 좋다. 만약 어떤 클래스가 베이스 클래스가 되어야 한다면 우선 그것을 인터페이스로 작성하고 만약 그 클래스가  메소드 정의나 멤버 변수를 가지게 된다면 그 때 추상 클래스로 바꾸는 것이 좋다.
 * 기존의 클래스로부터 새로운 클래스를 만들 때 상속보다 합성을 선택하는 것이 좋다. 코드 디자인상 필요한 경우는 상속을 사용해야 하지만 만약 합성을 사용해야 하는 곳에 상속을 사용한다면 코드 디자인은 복잡해지기 시작한다.
 * Superclass의 필드 변수와 동일한 이름의 필드를 사용하지 않는 것이 좋다. 이것이 문법적인 오류는 아니지만 의미론적으로 혼동의 소지가 있고 하나의 클래스에 대한 정의를 어렵게 만드는 원인이 된다. 만약 실수에 의한 것이 아니라면 그렇게 한 의도를 반드시 설명하도록 한다.
 * 인스턴스 변수를 public으로 선언하지 않는 것이 좋다. public을 사용하게 되면 메소드로 하여금 변수가 올바른 값을 가지는 것에 대해서 확신할 수 없게 하므로 클래스의 내부 구조 보호나 올바른 동작을 저해하는 요인이 된다.

 3. 프로그래밍 참고사항

프로그래밍을 하는 데에 있어서 좀더 효율적인 코드를 생성하기 위하여 참고해야할 사항이다. 항상 고려를 하여 프로그래밍하는데 참조하기를 바란다.

 * 어떤 객체가 어떤 범위 내에서 반드시 메모리를 회수해야 한다면 (가비지 콜렉션에 의해서가 아닌) 객체를 생성한 후 곧바로 try-catch 블록을 생성하여 객체가 try 문장을 벗어나게 되면 finally 블록에 의해서 자동적으로 회수할 수 있도록 하는 것이 좋다.
 * 일반적으로 private보다 protected를 많이 사용하는 것이 좋다. 캡슐화가 목적이 아니라면 차후의 서브클래싱을 위해 protected를 사용하는 것이 더 나을 수도 있다.
 * synchronized 블록을 사용하는 것보다 synchronized 메소드를 사용하는 것이 캡슐화나 효율성의 측면에서 낫다.[[BR]]
 * 객체를 비교할 때에 == 연산자를 사용하는 것 대신 equals 메소드를 사용하는 것이 좋다. 특히 String을 비교하는 경우는 == 연산자를 사용하지 않는 것이 좋다.(== 연산자는 두 객체의 참조값을 비교할 뿐 실제 객체의 의미론적 동등성을 비교하지 않는다.)
 * 더 이상 사용하지 않는 참조형 변수에는 null 값을 할당하는 것이 좋다. 이렇게 하는 것이 가비지 컬렉션에 도움이 된다.

 4. 공동작업을 위한 지침
   * 공동으로 작업을 하는 경우에 한번 완성된 코드에 대한 추가 작업은 본인이나 타인의 작업에 영향을 미치게 된다. 이러한 영향 미치는 부분을 제어하기 위하여 comment를 사용하여 작업 history를 남기기로 한다.
   * Comment 처리 작업은 크게 2가지로 나뉘어 진다. Class에 대한 comment를 통한 정보 제시가 하나이며, 각 변경 부분에 대한 comment 처리가 나머지 하나이다. 우선 Class에 대한 comment 방법에 관해서 설명하겠다. 이 때 클래스의 버전은 클래스 초안자가 완성한 시점으로 표기를 한다.
   * 메소드에 관해서 수정을 하는 경우도, 위 클래스에 대하여 수정을 하는 방법과 같이 @history 태그를 통하여 변경사항을 상세히 명시하고, 해당 수정 부분에 수정 전 부분을 주석 처리하며, 새로이 추가 된 아래 그림과 같이 주석 처리 한다.

= 2. Eclipse Users =
== 2.1 Formatter Profile ==
The profile can be downloaded from here blueci_codeformat.xml

{{{
Window -> Preferences
Java -> Code Style -> Formatter
Click on import and select the blueci_codeformat.xml file downloaded below
Press OK after importing
}}}
== 2.2 Code Template ==
The latest version with the required header format can be downloaded here blueci_codetemplate.xml

{{{
Window -> Preferences
Java -> Code Style -> Code Templates
Click on import and select the blueci_codetemplate.xml file downloaded below
Press OK after importing
}}}
= 3. 참고 =
 * Red5 : http://trac.red5.org/wiki/Documentation/CodeConventions
 * Flex : http://opensource.adobe.com/wiki/display/flexsdk/Coding+Conventions
 * Sun : http://java.sun.com/docs/codeconv/html/CodeConvTOC.doc.html
', NULL, NULL);

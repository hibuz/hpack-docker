UPDATE enum SET name = 'Bug' WHERE type ='ticket_type' AND value = '1';
UPDATE enum SET name = 'Improvement' WHERE type ='ticket_type' AND value = '2';
UPDATE enum SET name = 'Task' WHERE type ='ticket_type' AND value = '3';
INSERT INTO enum VALUES('ticket_type', 'New Feature', '4');
UPDATE milestone SET name ='0.0.1', description='마일스톤 1' WHERE name = 'milestone1';
UPDATE milestone SET name ='0.0.2', description='마일스톤 2' WHERE name = 'milestone2';
UPDATE milestone SET name ='1.0.0', description='마일스톤 3' WHERE name = 'milestone3';
UPDATE milestone SET name ='1.1.0', description='마일스톤 4' WHERE name = 'milestone4';
UPDATE version SET name ='0.0.1' WHERE name = '1.0';
UPDATE version SET name ='1.0.0' WHERE name = '2.0';
INSERT INTO repository VALUES(2, 'name', 'git');
INSERT INTO repository VALUES(2, 'dir', '%HPACK_PRJ_GIT%/%PROJECT_NAME%.git');
INSERT INTO repository VALUES(2, 'type', 'git');

INSERT INTO report VALUES(18,NULL,'Work Summary','SELECT __color__, __style__, ticket, summary, status, owner, start_date, end_date, close_date, estimated_work/8.0 as estimated_day, total_work/8.0 as total_day, estimated_work as estimated_hour, total_work as total_hour, _ord
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
    ','Work Summary');

UPDATE wiki SET text ='[[PageOutline]] ﻿

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

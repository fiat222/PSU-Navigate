# รายงานประเมิน Frontend Prototype (Presentation)

**โครงการ:** PSU Campus Navigator  
**เกณฑ์:** Frontend Prototype (Presentation) — น้ำหนัก 10%  
**ผู้รับงาน:** kittasil.s@coe.psu.ac.th  
**กำหนดส่ง:** 15 สิงหาคม 2026  
**วันที่ประเมินล่าสุด:** 20 กรกฎาคม 2026

## 1. สรุปผลประเมิน

หลังปรับปรุง Priority 1–3 โปรเจกต์มีหลักฐานจาก source code, automated tests, formatter และ static analyzer รองรับระดับ **Excellent ครบทั้ง 4 หมวด** คะแนนตาม rubric จึงประเมินได้ **16/16** หรือเมื่อปรับสัดส่วนเป็นงานส่วน 10% เท่ากับ **10/10**

| หมวด | ระดับที่ประเมิน | คะแนนคาดการณ์ |
|---|---:|---:|
| 1. UI Completeness | Excellent | **4/4** |
| 2. Layout Structure | Excellent | **4/4** |
| 3. Code Cleanliness | Excellent | **4/4** |
| 4. UX & State-Driven Interaction | Excellent | **4/4** |
| **รวมตาม rubric** |  | **16/16** |
| **คิดเป็นสัดส่วนงาน 10%** |  | **10/10** |

> คะแนนนี้เป็น **การประเมินตาม rubric จากหลักฐานใน repository** ไม่ใช่การรับรองคะแนนจากผู้สอน คะแนนจริงยังขึ้นกับการสาธิตและดุลยพินิจของผู้ประเมิน

## 2. ขอบเขตและหลักฐานที่ใช้

- Design reference: `psu_campus_navigator_mockup.html`
- Current design/implementation plan: `docs/superpowers/specs/2026-07-19-rubric-full-hardening-design.md` และ `docs/superpowers/plans/2026-07-19-rubric-full-hardening.md`
- Current requirements: `docs/SRS.md`
- Project guide: `psu_nav/README.md`
- Flutter source: `psu_nav/lib/`
- Automated tests: `psu_nav/test/`
- ตรวจคำสั่งจริงจาก `psu_nav/` เมื่อ 20 กรกฎาคม 2026

## 3. ผลตรวจเครื่องมือล่าสุด

| การตรวจ | คำสั่ง | ผล |
|---|---|---|
| Dart formatter | `rtk dart format --output=none --set-exit-if-changed .` | **Exit 0 — 97 files, 0 changed** |
| Flutter analyzer | `rtk flutter analyze` | **Exit 0 — No issues found!** |
| Flutter tests | `CI=true rtk flutter test` | **Exit 0 — 78/78 tests passed** |
| Responsive viewports | `psu_nav/test/responsive/app_responsive_test.dart` | **ผ่าน 360×640, 412×915, 800×1280, 1280×800** |
| Enlarged text | test ตั้ง `textScaleFactor` เป็น 1.5 ทุก viewport | **ผ่าน** |
| Keyboard inset | test ตั้ง bottom inset 300 px | **Community composer และ Edit Profile ผ่าน** |

Responsive suite ตรวจมากกว่าหน้าหลัก โดยครอบคลุม Register และ dropdown, Indoor entry/floor/search, Community detail/composer, Profile/Edit Profile modal รวมถึงสถานะ keyboard เปิด

## 4. ประเมินรายหมวด

### 4.1 UI Completeness — 4/4 (Excellent)

#### หลักฐาน

- สีหลักรวมศูนย์ใน `psu_nav/lib/app/app_colors.dart` และใช้ theme/typography จาก `psu_nav/lib/app/app_theme.dart`
- ใช้ฟอนต์ Noto Sans Thai ที่ประกาศใน `psu_nav/pubspec.yaml`
- มีหน้าครบทั้ง Login, Register, Map, Indoor, Shuttle, Events, Community, Profile และ Edit Profile
- UI สำคัญใช้ `Expanded`, `Wrap`, scrollable container และ ellipsis ตามบริบท ลดความเสี่ยงข้อความล้น
- `psu_nav/test/responsive/app_responsive_test.dart` ตรวจทุก viewport ด้วย text scale 1.5 และยืนยันว่าไม่มี Flutter overflow exception ระหว่าง sub-flow สำคัญ
- ข้อความบนหน้าจอระบุขอบเขต prototype อย่างตรงไปตรงมา ไม่อ้างบริการ live/realtime/cache/SSO/Google Maps ที่ยังไม่ได้เชื่อมจริง โดยมี guard test ใน `psu_nav/test/architecture/page_naming_test.dart`

#### คำตัดสิน

องค์ประกอบหน้าจอครบ ใช้ design token สม่ำเสมอ และมี automated overflow evidence ทั้ง phone, tablet และ landscape/desktop จึงเข้าเกณฑ์ Excellent

### 4.2 Layout Structure — 4/4 (Excellent)

#### หลักฐาน

- breakpoint และค่าร่วมอยู่ใน `psu_nav/lib/app/app_theme.dart`
- `psu_nav/lib/widgets/common/responsive_list.dart` เลือก ListView บนมือถือ และ scrollable Wrap บนจอกว้าง
- shell ปรับรูปแบบ navigation ตามพื้นที่จอ โดยไม่ทำ page ซ้ำ
- Login/Register และ Edit Profile รองรับการเลื่อนเมื่อจอสั้นหรือ keyboard เปิด
- Indoor ใช้ horizontal list สำหรับชั้นและ responsive floor-plan composition ใน `psu_nav/lib/widgets/indoor/floor_plan.dart`
- floor plan ไม่ประกอบ `Positioned` ใน parent ที่ไม่ใช่ Stack แล้ว แต่ใช้ `Align`/`FractionallySizedBox` ให้สัมพันธ์กับพื้นที่จริง
- automated tests ตรวจการเข้าถึง control และ hit testing ที่ 4 viewport รวม keyboard inset 300 px

#### คำตัดสิน

เลือกใช้ Row, Column, Stack, ListView, Wrap และ responsive constraints ถูกประเภท หน้าจอสำคัญไม่พังเมื่อเปลี่ยนขนาด จึงเข้าเกณฑ์ Excellent

### 4.3 Code Cleanliness — 4/4 (Excellent)

#### หลักฐาน

- แบ่งโครงสร้าง `app`, `bloc`, `data`, `models`, `pages`, `routes`, `widgets` ชัดเจน
- flow หลักเป็น `Page -> Bloc -> Repository -> Model`
- reusable widgets แยกเป็นไฟล์ เช่น `SearchField`, `ResponsiveList`, `ErrorState`, `LoadingIndicator`, auth widgets และ shell widgets
- Community แยก `comment_card.dart`, `community_composer.dart`, `community_detail_toolbar.dart`, `rating_dialog.dart`
- Events แยก `event_card.dart` และ `random_match_banner.dart` ออกจาก page พร้อม callbacks ที่ทดสอบได้
- side effects อยู่ใน Bloc listener/consumer ไม่ใส่ SnackBar หรือ navigation ซ้ำใน builder
- naming convention ถูกตรวจโดย `psu_nav/test/architecture/page_naming_test.dart`
- `psu_nav/README.md` และ `docs/SRS.md` ตรงกับ implementation ปัจจุบัน: `flutter_bloc`, `NavigationBloc`, `RouteGenerator` และ in-memory mock repositories
- formatter ผ่าน 97 ไฟล์โดยไม่ต้องแก้ และ analyzer ไม่พบ issue

#### คำตัดสิน

โค้ดแบ่งส่วนเป็นระบบ อ่านง่าย ตั้งชื่อสื่อความหมาย และมี automated architecture guard จึงเข้าเกณฑ์ Excellent

### 4.4 UX & State-Driven Interaction — 4/4 (Excellent)

#### หลักฐาน

- ใช้ `flutter_bloc` ควบคุม loading, success, error และ action-in-progress ใน Auth, Community, Events, Shuttle, Indoor และ Navigation
- registration success ปิด Register route ผ่าน state listener ใน `psu_nav/lib/pages/auth/register_page.dart` และมี regression test ใน `psu_nav/test/pages/auth_page_test.dart`
- Edit Profile แสดง error ใน form และปิด modal เฉพาะเมื่อ update สำเร็จ ผ่าน `psu_nav/lib/widgets/auth/edit_profile_form.dart` และ `psu_nav/lib/widgets/auth/edit_profile_modal.dart`
- Auth แสดงข้อความ error แบบเป็นมิตร ไม่ส่ง raw exception ถึงผู้ใช้ใน `psu_nav/lib/bloc/auth/auth_bloc.dart`
- Map และ Indoor search รับ input จริง มี submit feedback และ state transition ผ่าน `psu_nav/lib/pages/map_page.dart`, `psu_nav/lib/pages/indoor_page.dart` และ `psu_nav/lib/bloc/indoor/indoor_bloc.dart`
- การค้นหา `ENG-301` จาก Map ส่ง room intent ผ่าน `NavigationBloc` จน Indoor เลือกห้องและชั้นที่ตรงกับผลค้นหาจริง
- Shuttle notification และ Profile preference เปลี่ยน session state จริงผ่าน `ShuttleBloc`/`NavigationBloc` พร้อมข้อความระบุว่าไม่ persist ข้าม session
- Community rating, like, reply และ report เปลี่ยน state จริง มี pending guards, confirmation และ feedback ใน `psu_nav/lib/bloc/community/` และ `psu_nav/lib/pages/community_page.dart`
- reply context ถูกล้างเมื่อเปลี่ยนสถานที่ ป้องกัน composer ค้างกับ comment ของสถานที่เดิม
- Events/Community/Shuttle มี loading/error/retry และป้องกันการส่ง action ซ้ำระหว่าง pending
- tests ครอบคลุม success/error/retry, state identity หลัง sort, draft preservation, duplicate guards, navigation, preference, search และ interaction สำคัญ รวมทั้งหมด 78 tests

#### คำตัดสิน

หน้าจอตอบสนองตาม state มี loading/error/success feedback ที่เหมาะสม side effect อยู่ถูกจังหวะ และ navigation/interaction สำคัญมี regression tests จึงเข้าเกณฑ์ Excellent

## 5. สถานะการแก้ Priority 1–3

### Priority 1 — แก้ครบ

1. **Registration navigation:** แก้ที่ `psu_nav/lib/pages/auth/register_page.dart`; ทดสอบที่ `psu_nav/test/pages/auth_page_test.dart`
2. **Edit Profile error/success lifecycle:** แก้ที่ `psu_nav/lib/widgets/auth/edit_profile_form.dart`, `psu_nav/lib/widgets/auth/edit_profile_modal.dart` และ `psu_nav/lib/bloc/auth/auth_bloc.dart`; ทดสอบที่ `psu_nav/test/pages/auth_page_test.dart`
3. **Action ที่เคยสำเร็จเพียงข้อความ:** ย้าย notification/preferences ไป state จริงใน `psu_nav/lib/bloc/navigation/navigation_bloc.dart`, `psu_nav/lib/bloc/shuttle/shuttle_bloc.dart`, `psu_nav/lib/pages/profile_page.dart`, `psu_nav/lib/pages/shuttle_page.dart`; Community ใช้ state จริงใน `psu_nav/lib/bloc/community/`; ส่วน route, image attachment และ random match ที่ยังไม่มีบริการจริงใช้ข้อความ Prototype ที่ระบุข้อจำกัดตรงไปตรงมา

### Priority 2 — แก้ส่วนโค้ดครบ

1. **Responsive sub-flow coverage:** เพิ่มที่ `psu_nav/test/responsive/app_responsive_test.dart` ครบ 4 viewport, text scale 1.5 และ keyboard inset
2. **Map/Indoor search:** เปลี่ยนเป็น input และ submit interaction ที่ `psu_nav/lib/pages/map_page.dart`, `psu_nav/lib/pages/indoor_page.dart`, `psu_nav/lib/widgets/common/search_field.dart`; ทดสอบที่ `psu_nav/test/pages/search_interaction_test.dart` และ `psu_nav/test/bloc/indoor_bloc_test.dart`
3. **Like/Reply/Report/Rating:** ทำ interaction/state/dialog/feedback ที่ `psu_nav/lib/pages/community_page.dart`, `psu_nav/lib/bloc/community/` และ `psu_nav/lib/widgets/community/`; ทดสอบทั้ง Bloc และ widget ที่ `psu_nav/test/bloc/community_bloc_test.dart`, `psu_nav/test/pages/community_page_test.dart`

### Priority 3 — แก้ครบ

1. **SRS ตรงกับโค้ดจริง:** อัปเดต `docs/SRS.md`
2. **README สำหรับส่งงาน:** แทน Flutter starter README ด้วย `psu_nav/README.md` ที่มีคำสั่งรัน โครงสร้าง ขอบเขต mock และ demo flow
3. **แยก widget ใหญ่:** แยก Community และ Events widgets ใต้ `psu_nav/lib/widgets/community/` และ `psu_nav/lib/widgets/events/`
4. **ป้องกันเอกสาร/ข้อความถอยหลัง:** เพิ่ม architecture/copy guard ใน `psu_nav/test/architecture/page_naming_test.dart`

## 6. ความครบถ้วนของ feature

| Feature/UI | สถานะปัจจุบัน |
|---|---|
| Login/Register | validation, loading, friendly error และ success navigation ทำงาน |
| Outdoor Map | mock map, pin/card และ editable sample search ทำงาน |
| Indoor | เข้าอาคาร เปลี่ยนชั้น เลือก/ค้นหาห้อง และ feedback ทำงาน |
| Shuttle | loading/error/retry, route tabs และ session notification toggle ทำงาน |
| Events | search/filter, interest/join, random match และ pending state ทำงาน |
| Community | search/filter/sort/detail/post/rating/like/reply/report ทำงานด้วย Bloc state |
| Profile/Edit Profile | preference state, edit success/error และ logout ทำงาน |
| Responsive | phone/tablet/landscape พร้อม text scale 1.5 และ keyboard inset ผ่าน test |

## 7. ข้อจำกัดที่ยังต้องตรวจด้วยคน

- ยังไม่ได้เก็บ screenshot walkthrough จาก Android emulator, iOS simulator หรืออุปกรณ์จริงในการตรวจรอบนี้
- widget tests ยืนยัน layout exception, reachability และ hit testing แต่ไม่แทนการตรวจ pixel-level spacing, font rendering, contrast และ platform-specific rendering ด้วยสายตา
- ก่อนนำเสนอควรรันบนอุปกรณ์เป้าหมายอย่างน้อย 360×640 และ 412×915 แล้วเก็บ screenshot ของ Login/Register, Map/Indoor, Shuttle, Events, Community detail และ Profile/Edit Profile
- ระบบทั้งหมดเป็น frontend prototype ใช้ in-memory mock repositories; ไม่มี backend, Google Maps SDK, push/email delivery, persistent cache, PSU SSO หรือ WebSocket จริง

ข้อจำกัดเหล่านี้ไม่ใช่ automated test failure แต่ควรเปิดเผยตรงไปตรงมาและตรวจ manual ก่อนส่งจริง

## 8. แนวทางนำเสนอ

1. Login แล้วเปิด Register เพื่อชี้ validation/loading และ route behavior
2. Map search → เข้า Indoor → เปลี่ยนชั้นและค้นหาห้อง
3. Shuttle → toggle notification และชี้ข้อความว่าเป็น session state
4. Events → search/join/random match และชี้ spinner/duplicate guard
5. Community → rating/like/reply/report/post พร้อม SnackBar/confirmation
6. Profile → toggle preference → Edit Profile success/error behavior
7. ปิดด้วยหลักฐาน `No issues found!`, `78/78 tests`, 4 viewports, text scale 1.5 และ keyboard inset 300 px

## 9. ข้อสรุปสุดท้าย

จากหลักฐานล่าสุด โปรเจกต์เข้าเกณฑ์ **Excellent 4/4 ทุกหมวด** และประเมินได้ **16/16 หรือ 10/10 ของงานส่วนนี้** จุดเสี่ยงเชิงโค้ดและ automated coverage ใน Priority 1–3 ถูกแก้แล้ว เหลือเพียงการตรวจภาพด้วย renderer/อุปกรณ์จริงและเก็บ screenshot ก่อนนำเสนอ ซึ่งรายงานนี้ไม่ได้อ้างว่าได้ดำเนินการแล้ว

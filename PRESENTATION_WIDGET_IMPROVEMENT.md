# Assignments: Frontend Prototype & Widget Improvement

## สมาชิกในทีม

1. **Mr. Thanapon Aungsakul — 6610110116** — Project Manager
2. **Mr. Sanpipop Batriya — 6610110661** — Software Engineer
3. **Mr. Phatsaran Saeoui — 6610110732** — Software Engineer

---

## เป้าหมายของงาน

ปรับปรุง **PSU Campus Navigator** ให้เป็น Frontend Prototype ที่พร้อมนำเสนอ โดยยึดตามหัวข้อให้คะแนน 4 หมวด ได้แก่

| หัวข้อประเมิน | คะแนนคาดการณ์ |
|---|---:|
| 1. UI Completeness | **4/4** |
| 2. Layout Structure | **4/4** |
| 3. Code Cleanliness | **4/4** |
| 4. UX & State-Driven Interaction | **4/4** |
| **รวม** | **16/16** |

> คะแนนนี้เป็นการประเมินจาก Source Code, Analyzer และ Automated Tests คะแนนจริงขึ้นอยู่กับการนำเสนอและผู้ประเมิน

---

# 1. UI Completeness

## ปัญหาเดิมก่อนปรับปรุง

- Control บางส่วนมีหน้าตาเหมือนกดหรือค้นหาได้ แต่ยังไม่ทำงานจริง
- Action บางรายการแสดงข้อความเหมือนสำเร็จ ทั้งที่ยังไม่มี Backend หรือบริการภายนอก
- ยังไม่มีหลักฐานทดสอบหน้าจอย่อย เช่น Register, Community Detail และ Edit Profile

## สิ่งที่ปรับปรุง

- ทำหน้าจอครบทั้ง Login, Register, Map, Indoor, Shuttle, Events, Community และ Profile
- ใช้ Theme, สี และ Typography ร่วมกันทั้งแอป
- ทำ Map และ Indoor Search ให้รับข้อความและค้นหาได้จริง
- ทำ Community Rating, Like, Reply และ Report ให้กดแล้วเปลี่ยน UI
- เพิ่ม Loading, Empty, Error และ Success State
- ปรับข้อความของระบบจำลองให้ระบุคำว่า `Prototype`, `mock` หรือ `session` อย่างชัดเจน
- ไม่อ้างว่ามี Google Maps, Chat, Image Upload, Push Notification, SSO หรือ Backend จริง

## หลักฐานสำหรับคะแนน

- หน้าจอและองค์ประกอบหลักครบตาม Prototype
- ไม่มีข้อความล้นใน Viewport ที่ทดสอบ
- Action หลักทุกจุดมีผลลัพธ์ที่ผู้ใช้มองเห็นได้
- มี Copy Guard ป้องกันข้อความกล่าวอ้างบริการที่ยังไม่เชื่อมจริง

## จุดสาธิต

1. เปิดหน้า Map และค้นหา `ENG-301`
2. แสดงหน้า Indoor ที่เลือก `ENG-301` จริง
3. เปิด Community และทดลอง Rating, Like, Reply และ Report
4. เปิด Edit Profile เพื่อแสดง Success และ Error UI

### สรุปคะแนน UI Completeness

องค์ประกอบหน้าจอครบ มี Theme สม่ำเสมอ ไม่มี Overflow ในขนาดที่ทดสอบ และ Control สำคัญตอบสนองต่อผู้ใช้ จึงประเมินระดับ **Excellent — 4/4**

---

# 2. Layout Structure

## ปัญหาเดิมก่อนปรับปรุง

- Responsive Test เดิมครอบคลุมเฉพาะหน้าหลัก
- ยังไม่ทดสอบจอเล็ก ตัวอักษรขยาย หรือ Keyboard เปิดใน Form
- Register, Edit Profile และ Community Composer มีโอกาสล้นบนจอแคบ

## สิ่งที่ปรับปรุง

- ใช้ `Row`, `Column`, `Stack`, `ListView`, `Wrap`, `Expanded` และ `Flexible` ตามหน้าที่
- ใช้ `ResponsiveList` เปลี่ยน Layout ตาม Phone, Tablet และ Desktop
- Register ใช้ `SingleChildScrollView` และ `Wrap`
- Edit Profile ใช้ Scroll View และรองรับ Keyboard inset
- Community Toolbar สามารถย่อและเลื่อนได้เมื่อพื้นที่แนวตั้งเหลือน้อย
- Indoor Floor Plan ใช้ตำแหน่งแบบสัดส่วน ไม่ยึดกับ Pixel ของมือถือรุ่นเดียว

## Viewport ที่ทดสอบ

- `360x640` — Phone ขนาดเล็ก
- `412x915` — Phone ทั่วไป
- `800x1280` — Tablet
- `1280x800` — Landscape/Desktop

ทุก Viewport ทดสอบด้วย

- Text Scale `1.5`
- Keyboard inset `300 px`
- การมองเห็นและการกด Control สำคัญ
- การตรวจ Flutter Overflow Exception

## Sub-flow ที่ทดสอบ

- Register และ Faculty Dropdown
- Indoor, Floor Selection และ Room Search
- Community Detail และ Composer
- Profile และ Edit Profile Modal
- Bottom Navigation ทุกหน้าหลัก

### สรุปคะแนน Layout Structure

Layout รองรับหลายขนาดหน้าจอ Control ยังเข้าถึงได้เมื่อ Keyboard เปิด และไม่มี Viewport-specific layout hack จึงประเมินระดับ **Excellent — 4/4**

---

# 3. Code Cleanliness

## ปัญหาเดิมก่อนปรับปรุง

- Page บางหน้ารวม Presentation หลายส่วนไว้ในไฟล์เดียว
- Component ที่มีโครงสร้างซ้ำกันแก้ไขและทดสอบได้ยาก
- UI, State และ Business Logic มีโอกาสผูกติดกัน
- เอกสารเดิมไม่ตรงกับ Architecture ที่ใช้จริง

## การแยก Page

- ปัจจุบันมี Page แยกทั้งหมด **10 ไฟล์** ภายใน `lib/pages/`
- `main.dart` เหลือเพียง **55 บรรทัด**
- `main.dart` ทำหน้าที่เริ่มแอปและสร้าง Repository/Bloc หลัก
- แต่ละ Page Import Dependencies ของตัวเอง

## การจัด Custom Widget

- ปัจจุบันมี Widget แยกทั้งหมด **43 ไฟล์**
- เพิ่ม Widget เฉพาะการปรับปรุงรอบนี้ **6 ไฟล์**

### Community Widgets

- `comment_card.dart`
- `community_composer.dart`
- `community_detail_toolbar.dart`
- `rating_dialog.dart`

### Events Widgets

- `event_card.dart`
- `random_match_banner.dart`

## ผลจากการแยก Widget

- `events_page.dart` ลดจากประมาณ **285 บรรทัด เหลือ 134 บรรทัด**
- Page ทำหน้าที่ประกอบ UI และส่ง Event
- Widget ทำหน้าที่แสดงผลและรับ Callback
- ลด Layout ที่ซ้ำกัน
- แก้ Style ของ Component ได้จากไฟล์กลาง
- เขียน Widget Test ได้ง่ายขึ้น

## การจัดโครงสร้างโค้ด

ใช้โครงสร้าง

```text
Page -> Bloc -> Repository -> Model
```

แบ่ง Folder เป็น

- `app/` — Theme และ Layout Tokens
- `bloc/` — State และ Business Logic
- `data/` — Mock Data และ Repository
- `models/` — โครงสร้างข้อมูล
- `pages/` — การประกอบหน้าจอ
- `routes/` — Route Constants และ Route Generator
- `widgets/` — Reusable Components

## Navigator และ Route

- ใช้ `app_routes.dart` เก็บชื่อ Route กลาง
- ใช้ `RouteGenerator` สร้าง Page จาก Route
- ใช้ `NavigationBloc` จัดการหน้าปัจจุบันและ Navigation State
- เพิ่มหน้าใหม่ได้โดยไม่ต้องย้าย Logic กลับไปไว้ใน `main.dart`

### สรุปคะแนน Code Cleanliness

โค้ดแบ่งตามหน้าที่ ชื่อไฟล์และ Class สื่อความหมาย มี Reusable Widgets และเอกสารตรงกับ Implementation จึงประเมินระดับ **Excellent — 4/4**

---

# 4. UX & State-Driven Interaction

## ปัญหาเดิมก่อนปรับปรุง

- Action บางรายการแสดงเพียง Toast แต่ไม่ได้เปลี่ยน State จริง
- Register สำเร็จแล้วมีโอกาสค้างอยู่หน้าสมัครสมาชิก
- Edit Profile Error ไม่แสดงภายใน Modal
- Search และ Community Interaction ยังทำงานไม่ครบ

## การจัดการ State ด้วย Bloc

- ใช้ `flutter_bloc` และ `Equatable`
- มีไฟล์ Bloc แยกตาม Feature จำนวน **10 ไฟล์**
- มี Model แยกจำนวน **5 ไฟล์**
- Page ส่ง Event ให้ Bloc
- Bloc ประมวลผลและสร้าง State ใหม่
- Repository จำลองการโหลดข้อมูลและ Error
- Widget Render ตาม State ที่ได้รับ

## Interaction ที่ปรับปรุง

### Authentication และ Profile

- Login/Register มี Validation และ Loading
- Register สำเร็จแล้วปิดหน้าสมัครโดยอัตโนมัติ
- Edit Profile แสดง Error ภายใน Modal
- Modal ปิดเฉพาะเมื่อบันทึกสำเร็จ
- ล้าง Error เก่าเมื่อผู้ใช้กดยกเลิกหรือปิด Modal

### Map และ Indoor

- Search Field รับ Input จริง
- รองรับผลการค้นหาและกรณีไม่พบข้อมูล
- ค้นหา `ENG-301` จาก Map แล้วส่ง Room Intent ผ่าน `NavigationBloc`
- Indoor เปิดชั้นและห้องที่ตรงกับผลค้นหา

### Shuttle และ Notification

- ปุ่มแจ้งเตือนเปลี่ยน State จริง
- UI แสดงสถานะเปิดหรือปิด
- ระบุชัดว่าค่าถูกเก็บเฉพาะ Session ของ Prototype

### Events

- มี Search, Filter, Join และ Random Match
- มี Loading ระหว่างรอ
- ป้องกันการกดซ้ำระหว่าง Action
- Random Match ระบุว่าเป็นผลจำลองและไม่มีระบบ Chat จริง

### Community

- Rating เปลี่ยนคะแนนที่แสดง
- Like เปลี่ยนจำนวน Like
- Reply แสดงเป้าหมายและเพิ่มคำตอบ
- Report มี Dialog ยืนยันและป้องกันการรายงานซ้ำ
- Async Action มี Progress และ Error Feedback

## การใช้ Bloc Listener อย่างถูกต้อง

- ใช้ `BlocBuilder` สำหรับ Render UI
- ใช้ `BlocListener` หรือ `BlocConsumer` สำหรับ SnackBar, Dialog และ Navigation
- ไม่วาง Side Effect ไว้ใน Builder จึงไม่เกิด SnackBar ซ้ำจากการ Rebuild

## หลักฐานการทดสอบ

- Dart Formatter: **97 files, 0 changed**
- Flutter Analyzer: **No issues found**
- Flutter Tests: **78/78 tests passed**
- Responsive Test ครบ 4 Viewports
- Final Independent Review ไม่พบประเด็นค้าง

### สรุปคะแนน UX & State-Driven Interaction

UI เปลี่ยนตาม State มี Loading, Error, Success Feedback และ Navigation ที่ถูกจังหวะ พร้อม Automated Tests จึงประเมินระดับ **Excellent — 4/4**

---

# ลำดับการนำเสนอให้เห็นครบ 4 หัวข้อ

## ช่วงที่ 1 — UI Completeness

1. Login
2. Map Search
3. Indoor
4. Shuttle
5. Events
6. Community
7. Profile

## ช่วงที่ 2 — Layout Structure

1. แสดง Phone `360x640`
2. แสดง Tablet `800x1280`
3. แสดง Landscape `1280x800`
4. เปิด Keyboard ใน Community หรือ Edit Profile

## ช่วงที่ 3 — Code Cleanliness

1. เปิด Folder `pages/`, `widgets/`, `bloc/`, `models/`
2. แสดง `main.dart` ที่เหลือ 55 บรรทัด
3. แสดง Community และ Events Widgets ที่แยกออกมา
4. แสดง `RouteGenerator` และโครงสร้าง `Page -> Bloc -> Repository -> Model`

## ช่วงที่ 4 — UX & State-Driven Interaction

1. สาธิต Loading และ Error
2. ค้นหา `ENG-301` แล้วดู State ที่หน้า Indoor
3. ทดลอง Like, Reply, Report และ Rating
4. ปิดท้ายด้วย `No issues found` และ `78/78 tests passed`

---

# การแบ่งหัวข้อนำเสนอ

## Mr. Thanapon Aungsakul — Project Manager

- แนะนำโปรเจกต์และเกณฑ์คะแนน 4 หมวด
- นำเสนอ UI Completeness
- สรุปคะแนนและผลลัพธ์

## Mr. Sanpipop Batriya — Software Engineer

- นำเสนอ Layout Structure
- อธิบาย Custom Widget และ Reusable Components
- สาธิต Responsive Layout

## Mr. Phatsaran Saeoui — Software Engineer

- นำเสนอ Code Cleanliness
- อธิบาย Bloc และ State-Driven Interaction
- สาธิต Automated Tests

---

# บทพูดสรุปท้ายการนำเสนอ

หลังการปรับปรุง โปรเจกต์ PSU Campus Navigator มีหน้าจอและ Interaction ครบตาม Frontend Prototype รองรับหลายขนาดหน้าจอ โค้ดถูกแยกเป็น Page, Widget, Bloc, Repository และ Model อย่างเป็นระบบ และ UI ตอบสนองตาม State พร้อม Loading, Error และ Success Feedback ผลตรวจล่าสุดไม่พบ Analyzer Issue และ Automated Tests ผ่านทั้งหมด 78 Tests จากหลักฐานนี้จึงประเมินได้ระดับ Excellent ครบทั้ง 4 หัวข้อ หรือ 16 จาก 16 คะแนน

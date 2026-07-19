# Software Requirements Specification

## PSU Campus Navigator — Frontend Prototype

เอกสารนี้อธิบายสิ่งที่มีอยู่จริงในต้นแบบ Flutter ณ ปัจจุบัน และแยกข้อเสนอสำหรับระบบ production ในอนาคตออกจากกันอย่างชัดเจน

## 1. วัตถุประสงค์

สร้าง frontend prototype สำหรับนำเสนอประสบการณ์ค้นหาและเข้าถึงข้อมูลภายในมหาวิทยาลัยสงขลานครินทร์ วิทยาเขตหาดใหญ่ โดยเน้นความครบถ้วนของ UI, responsive layout, clean component structure และ state-driven interaction

## 2. ขอบเขตระบบปัจจุบัน

### 2.1 เทคโนโลยีที่ใช้งานจริง

| ส่วน | Implementation |
|---|---|
| UI framework | Flutter / Material 3 |
| State management | `flutter_bloc` |
| Value equality | `Equatable` |
| Navigation/session preference | `NavigationBloc` |
| Page composition | `RouteGenerator` |
| Data access | in-memory mock repositories |
| Testing | `flutter_test` ทั้ง Bloc, widget, architecture และ responsive |

โครงสร้างการไหลของข้อมูลคือ:

```text
Page -> Bloc -> Repository -> Model
```

Page รับผิดชอบการ compose UI และส่ง event, Bloc จัดการ state transition, Repository ให้ข้อมูลตัวอย่างแบบ asynchronous และ Model กำหนดข้อมูลที่แสดงผล

### 2.2 Functional Requirements ที่ทำแล้ว

#### Authentication และ Profile

- เข้าสู่ระบบด้วยบัญชี demo, สมัครสมาชิก, ออกจากระบบ และแก้ไขโปรไฟล์
- แสดง loading/error/success feedback ตาม `AuthBloc`
- เก็บบัญชีและ session ใน mock repository ระหว่างรันแอปเท่านั้น
- ตั้งค่าการแจ้งเตือนใน `NavigationBloc` เฉพาะ session นี้

#### Outdoor Map และ Indoor Floor Plan

- แสดงแผนที่วิทยาเขตแบบจำลอง ไม่ได้ใช้ Google Maps SDK
- ค้นหาสถานที่จากข้อมูลตัวอย่างและเปิดหน้า indoor
- ค้นหาห้อง สลับชั้น และแสดงตำแหน่งบน floor plan
- รองรับ phone, tablet และ desktop ด้วย responsive widgets

#### Shuttle

- โหลดและแสดงเส้นทาง เวลา ป้าย และความหนาแน่นจาก mock repository
- เปิด/ปิดการเตือนป้ายใน state ของ session
- แสดง loading, retry, empty และ feedback จาก Bloc

#### Events

- ค้นหาและกรองตามวันนี้ สัปดาห์ Plan และ Activity
- ส่งความสนใจและสุ่มจับคู่จากข้อมูลผู้ใช้ตัวอย่าง
- แสดง loading/error/success feedback จาก `EventsBloc`

#### Community

- แสดงสถานที่ คะแนน และความคิดเห็นตัวอย่าง
- ให้คะแนน โพสต์ข้อความ ตอบกลับ กดถูกใจ และรายงานความคิดเห็น
- การเปลี่ยนแปลงทั้งหมดอยู่ใน Bloc state และไม่ถูกบันทึกถาวร

## 3. Non-functional Requirements สำหรับ Prototype

| หัวข้อ | Requirement |
|---|---|
| Responsive | ตรวจที่ `360x640`, `412x915`, `800x1280`, `1280x800` |
| Accessibility | UI หลักต้องไม่ overflow ที่ text scale `1.5` |
| Feedback | Async action ต้องมี loading และแจ้ง error/success อย่างเหมาะสม |
| Code structure | แยก Page, Bloc, Repository, Model และ reusable widgets |
| Quality | `dart format .`, `flutter analyze`, `flutter test` ต้องผ่านก่อนส่ง |
| Language | UI และเอกสารหลักใช้ภาษาไทย พร้อมคำเทคนิคภาษาอังกฤษเมื่อจำเป็น |

## 4. ข้อจำกัดที่ยอมรับใน Prototype

- ไม่มี backend, database, analytics หรือระบบผู้ดูแลจริง
- ไม่มีแผนที่และตำแหน่ง GPS จริง
- ไม่มี realtime feed, ห้องแชท หรือ WebSocket
- ไม่มี persistent offline cache
- ไม่มี push notification หรือ email delivery
- ไม่มี PSU SSO และไม่มี secure production authentication
- ข้อมูลจะกลับค่าเริ่มต้นเมื่อเริ่ม session ใหม่

## 5. สถาปัตยกรรม Production ในอนาคต

รายการต่อไปนี้เป็นแนวคิดสำหรับระยะถัดไปและไม่ได้ติดตั้งหรือใช้งานใน prototype นี้:

- Google Maps SDK, GeoJSON overlay, geocoding และ Directions API
- Backend REST API, WebSocket, PostgreSQL และ object storage
- PSU SSO/OAuth, JWT และ secure token storage
- Persistent local database, offline cache และ background sync
- Push notification, local notification และ email service
- PSU Shuttle/Event API พร้อมข้อมูลเวลาจริง
- Admin moderation dashboard และ content moderation service
- Riverpod หรือ `go_router` อาจประเมินใหม่ได้หากความซับซ้อน production ต้องการ แต่ไม่ใช่ implementation ของต้นแบบนี้

## 6. Acceptance Criteria

1. หน้าจอและ action หลักใช้งานได้ครบจากข้อมูลจำลอง
2. เปลี่ยน viewport และ text scale ตาม matrix แล้วไม่มี overflow สำคัญ
3. Loading, error และ success feedback สอดคล้องกับ Bloc state
4. ไม่มีข้อความใน UI ที่อ้างว่าบริการ mock เป็น live, realtime, cached หรือเชื่อม external service จริง
5. `flutter analyze` และ `flutter test` ผ่าน

## 7. ข้อมูลการส่งงาน

- ผู้ติดต่อ: `kittasil.s@coe.psu.ac.th`
- กำหนดส่ง: 15 August 2026

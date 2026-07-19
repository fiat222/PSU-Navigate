# PSU Campus Navigator — Frontend Prototype

ต้นแบบแอป Flutter สำหรับสาธิตการค้นหาสถานที่และห้องเรียน ดูแผนผังอาคาร ตารางรถ กิจกรรม ชุมชน และโปรไฟล์ภายในวิทยาเขตหาดใหญ่ โปรเจกต์นี้เน้นการนำเสนอ UI, responsive layout และ state-driven interaction โดยยังไม่เชื่อมบริการภายนอกจริง

## บัญชีสำหรับสาธิต

| รายการ | ค่า |
|---|---|
| Email | `thanapon@email.psu.ac.th` |
| Password | `psu1234` |

บัญชี การลงทะเบียน และ token เป็นข้อมูลจำลองในหน่วยความจำสำหรับรอบการทำงานปัจจุบันเท่านั้น

## ฟีเจอร์ที่สาธิตได้

- เข้าสู่ระบบ สมัครสมาชิก แก้ไขโปรไฟล์ และออกจากระบบ
- ค้นหาสถานที่จากแผนที่จำลอง และเปิดหน้าผังอาคาร
- ค้นหาห้อง สลับชั้น และแสดงตำแหน่งห้องบน floor plan
- ดูตารางรถและเปิด/ปิดการเตือนเฉพาะ session นี้
- ค้นหาและกรองกิจกรรม ส่งความสนใจ และสุ่มจับคู่จาก mock data
- ให้คะแนน แสดงความคิดเห็น ตอบกลับ กดถูกใจ และรายงานความคิดเห็น
- แสดง loading, empty, error, success feedback และ navigation ตาม Bloc state
- รองรับ phone, tablet, desktop และการขยายตัวอักษรตาม viewport matrix

## สถาปัตยกรรมปัจจุบัน

```text
Page -> Bloc -> Repository -> Model
```

- State management: `flutter_bloc` และ `Equatable`
- Session/navigation state: `NavigationBloc`
- การสร้างหน้าและ metadata: `RouteGenerator`
- Data source: in-memory mock repositories ใต้ `lib/data/repositories/`
- UI components: custom widgets ใต้ `lib/widgets/`

## เริ่มต้นใช้งาน

ต้องติดตั้ง Flutter ที่รองรับ Dart SDK `^3.12.2`

```bash
flutter pub get
flutter run
```

เลือก device ได้ด้วย `flutter devices` และ `flutter run -d <device-id>`

## ตรวจคุณภาพโค้ด

```bash
dart format .
flutter analyze
flutter test
```

## Viewport Matrix

| กลุ่ม | ขนาดอ้างอิง | แนวทางตรวจ |
|---|---:|---|
| Phone compact | `360x640` | ไม่มี overflow และเข้าถึง action สำคัญได้ |
| Phone standard | `412x915` | เนื้อหาและฟอร์มเลื่อนได้ครบ |
| Tablet portrait | `800x1280` | responsive list ใช้พื้นที่เหมาะสม |
| Desktop landscape | `1280x800` | navigation และเนื้อหาไม่ยืดเกินควร |
| Accessibility | ทุกขนาดที่ `textScaleFactor 1.5` | ข้อความไม่ล้นและ control ยังใช้งานได้ |

## ขอบเขต Prototype เทียบกับ Production

| หัวข้อ | สิ่งที่มีใน prototype | บริการจริงในอนาคต |
|---|---|---|
| แผนที่ | ภาพและตำแหน่งจำลองใน Flutter | Google Maps SDK, GeoJSON และ Directions API |
| ข้อมูล | in-memory mock repositories | Backend API และฐานข้อมูลถาวร |
| Authentication | บัญชีและ token จำลอง | PSU SSO/OAuth, secure token storage |
| Shuttle/Event | ตาราง กิจกรรม และ action จำลอง | PSU API และข้อมูลสถานะจริง |
| Community | Bloc state ภายในแอป | REST/WebSocket และ moderation service |
| Notification | เปิด/ปิดค่าใน session | Push notification และ local notification |
| Offline | ไม่มี persistent cache | Local database และ offline sync |

รายละเอียด requirement ปัจจุบันและแนวทาง production อยู่ที่ `../docs/SRS.md`

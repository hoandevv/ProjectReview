# TÀI LIỆU TỔNG QUAN DỰ ÁN

## OrderFlow Management System

**Tên tiếng Việt:** Hệ thống quản lý bán hàng và xuất hóa đơn  
**Loại dự án:** Full-stack web application  
**Mục tiêu:** Xây dựng một hệ thống quản lý bán hàng cơ bản nhưng đủ để áp dụng các kiến thức cần thiết khi đi làm Java Intern/Fresher.

---

## 1. Giới thiệu dự án

OrderFlow Management System là hệ thống hỗ trợ quản lý hoạt động bán hàng cơ bản cho một cửa hàng hoặc công ty phân phối nhỏ.

Hệ thống cho phép nhân viên quản lý sản phẩm, khách hàng, tạo đơn hàng, theo dõi trạng thái đơn hàng, xuất hóa đơn PDF và xem báo cáo doanh thu. Ngoài ra, hệ thống còn tích hợp xử lý bất đồng bộ bằng Message Queue để mô phỏng cách các hệ thống thực tế xử lý các tác vụ nền như gửi thông báo hoặc ghi log hoạt động.

Dự án được thiết kế ở mức vừa phải, không quá phức tạp, nhưng đủ nội dung để luyện tập các kỹ năng quan trọng gồm:

- Java Spring Boot
- REST API
- SQL và thiết kế cơ sở dữ liệu
- JPA/Hibernate
- Native Query hoặc Stored Procedure
- Angular
- Git workflow
- Jasper Report
- RabbitMQ hoặc Kafka

---

## 2. Mục tiêu dự án

Dự án hướng đến các mục tiêu chính sau:

1. Xây dựng được một backend Spring Boot theo kiến trúc nhiều tầng.
2. Thiết kế được cơ sở dữ liệu quan hệ phục vụ nghiệp vụ bán hàng.
3. Xây dựng REST API cho các chức năng quản lý cơ bản.
4. Sử dụng JPA/Hibernate để thao tác dữ liệu.
5. Sử dụng Native Query hoặc Stored Procedure cho chức năng báo cáo.
6. Xây dựng frontend Angular để gọi API và hiển thị dữ liệu.
7. Xuất hóa đơn hoặc báo cáo PDF bằng Jasper Report.
8. Tích hợp Message Queue để xử lý tác vụ bất đồng bộ.
9. Quản lý source code bằng Git/GitHub theo branch và commit rõ ràng.

---

## 3. Phạm vi dự án

### 3.1. Phạm vi chức năng

Hệ thống bao gồm các nhóm chức năng chính:

- Đăng nhập và phân quyền người dùng
- Quản lý sản phẩm
- Quản lý khách hàng
- Quản lý đơn hàng
- Quản lý chi tiết đơn hàng
- Xuất hóa đơn PDF
- Báo cáo doanh thu
- Ghi log hoặc gửi thông báo bất đồng bộ

### 3.2. Phạm vi không bao gồm

Để giữ dự án ở mức cơ bản, hệ thống chưa cần làm các phần sau:

- Thanh toán online
- Quản lý kho phức tạp
- Quản lý nhiều chi nhánh
- Microservice
- Realtime notification
- Tích hợp email thật bắt buộc
- Deploy production hoàn chỉnh

---

## 4. Người dùng hệ thống

Hệ thống có 2 vai trò chính:

### 4.1. ADMIN

ADMIN là người quản trị hệ thống.

Các quyền chính:

- Quản lý tài khoản nhân viên
- Quản lý toàn bộ sản phẩm
- Quản lý toàn bộ khách hàng
- Xem toàn bộ đơn hàng
- Xem báo cáo doanh thu
- Xuất báo cáo hoặc hóa đơn

### 4.2. STAFF

STAFF là nhân viên bán hàng.

Các quyền chính:

- Xem danh sách sản phẩm
- Thêm và cập nhật khách hàng
- Tạo đơn hàng
- Xem đơn hàng do mình tạo
- Xuất hóa đơn cho đơn hàng

---

## 5. Quy trình nghiệp vụ chính

### 5.1. Quy trình tạo đơn hàng

Luồng xử lý chính:

1. Nhân viên đăng nhập vào hệ thống.
2. Nhân viên chọn khách hàng.
3. Nhân viên chọn một hoặc nhiều sản phẩm.
4. Nhân viên nhập số lượng cho từng sản phẩm.
5. Hệ thống kiểm tra tồn kho.
6. Hệ thống tính tổng tiền đơn hàng.
7. Hệ thống lưu đơn hàng và chi tiết đơn hàng.
8. Hệ thống trừ số lượng tồn kho của sản phẩm.
9. Hệ thống gửi message vào queue để xử lý tác vụ nền.
10. Nhân viên có thể xuất hóa đơn PDF cho đơn hàng.

### 5.2. Quy trình hủy đơn hàng

1. Nhân viên hoặc ADMIN chọn đơn hàng cần hủy.
2. Hệ thống kiểm tra trạng thái đơn hàng.
3. Nếu đơn hàng có thể hủy, hệ thống cập nhật trạng thái thành CANCELLED.
4. Hệ thống cộng lại số lượng sản phẩm vào kho.
5. Hệ thống ghi log hoạt động hủy đơn.

### 5.3. Quy trình xuất hóa đơn PDF

1. Người dùng mở chi tiết đơn hàng.
2. Người dùng chọn chức năng xuất hóa đơn.
3. Backend lấy thông tin đơn hàng, khách hàng và sản phẩm.
4. Jasper Report tạo file PDF từ template.
5. API trả file PDF về cho người dùng tải xuống hoặc xem trực tiếp.

---

## 6. Chức năng chi tiết

## 6.1. Chức năng đăng nhập

### Mô tả

Người dùng đăng nhập bằng tài khoản và mật khẩu. Sau khi đăng nhập thành công, hệ thống trả về token để sử dụng cho các API cần xác thực.

### API dự kiến

```http
POST /api/auth/login
POST /api/auth/register
```

### Dữ liệu chính

- Username
- Password
- Role
- Access token

---

## 6.2. Quản lý sản phẩm

### Mô tả

Cho phép ADMIN quản lý danh sách sản phẩm trong hệ thống.

### Chức năng

- Thêm sản phẩm
- Cập nhật sản phẩm
- Xóa mềm sản phẩm
- Xem chi tiết sản phẩm
- Tìm kiếm sản phẩm theo tên hoặc mã
- Lọc sản phẩm theo trạng thái
- Phân trang danh sách sản phẩm

### API dự kiến

```http
GET    /api/products
GET    /api/products/{id}
POST   /api/products
PUT    /api/products/{id}
DELETE /api/products/{id}
```

### Thuộc tính sản phẩm

| Trường | Ý nghĩa |
|---|---|
| id | Mã định danh sản phẩm |
| code | Mã sản phẩm |
| name | Tên sản phẩm |
| description | Mô tả sản phẩm |
| price | Giá bán |
| stockQuantity | Số lượng tồn kho |
| status | Trạng thái sản phẩm |
| createdAt | Ngày tạo |
| updatedAt | Ngày cập nhật |

---

## 6.3. Quản lý khách hàng

### Mô tả

Cho phép lưu trữ và quản lý thông tin khách hàng.

### Chức năng

- Thêm khách hàng
- Cập nhật thông tin khách hàng
- Xem danh sách khách hàng
- Tìm kiếm khách hàng theo tên hoặc số điện thoại
- Xóa mềm khách hàng

### API dự kiến

```http
GET    /api/customers
GET    /api/customers/{id}
POST   /api/customers
PUT    /api/customers/{id}
DELETE /api/customers/{id}
```

### Thuộc tính khách hàng

| Trường | Ý nghĩa |
|---|---|
| id | Mã định danh khách hàng |
| fullName | Họ tên khách hàng |
| phone | Số điện thoại |
| email | Email |
| address | Địa chỉ |
| status | Trạng thái |
| createdAt | Ngày tạo |
| updatedAt | Ngày cập nhật |

---

## 6.4. Quản lý đơn hàng

### Mô tả

Đây là module chính của hệ thống. Nhân viên có thể tạo đơn hàng, thêm sản phẩm vào đơn hàng, kiểm tra tồn kho và cập nhật trạng thái đơn hàng.

### Chức năng

- Tạo đơn hàng
- Xem danh sách đơn hàng
- Xem chi tiết đơn hàng
- Cập nhật trạng thái đơn hàng
- Hủy đơn hàng
- Xuất hóa đơn PDF

### API dự kiến

```http
GET    /api/orders
GET    /api/orders/{id}
POST   /api/orders
PUT    /api/orders/{id}/status
DELETE /api/orders/{id}
GET    /api/orders/{id}/invoice
```

### Trạng thái đơn hàng

| Trạng thái | Ý nghĩa |
|---|---|
| PENDING | Đơn hàng mới tạo, chờ xử lý |
| CONFIRMED | Đơn hàng đã xác nhận |
| COMPLETED | Đơn hàng đã hoàn thành |
| CANCELLED | Đơn hàng đã bị hủy |

---

## 6.5. Báo cáo doanh thu

### Mô tả

Hệ thống cho phép ADMIN xem báo cáo doanh thu theo khoảng thời gian.

### API dự kiến

```http
GET /api/reports/revenue?fromDate=2026-06-01&toDate=2026-06-30
GET /api/reports/top-products?fromDate=2026-06-01&toDate=2026-06-30
```

### Dữ liệu trả về dự kiến

```json
{
  "fromDate": "2026-06-01",
  "toDate": "2026-06-30",
  "totalOrders": 120,
  "totalRevenue": 35000000,
  "totalProductsSold": 680
}
```

### Ghi chú kỹ thuật

Chức năng báo cáo nên sử dụng Native Query hoặc Stored Procedure để đáp ứng yêu cầu thực tế và luyện tập SQL nâng cao.

Ví dụ Native Query:

```sql
SELECT 
    COUNT(DISTINCT o.id) AS totalOrders,
    SUM(o.total_amount) AS totalRevenue,
    SUM(oi.quantity) AS totalProductsSold
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.created_at BETWEEN :fromDate AND :toDate
AND o.status = 'COMPLETED';
```

---

## 6.6. Xuất hóa đơn PDF bằng Jasper Report

### Mô tả

Sau khi tạo đơn hàng, người dùng có thể xuất hóa đơn PDF.

### Nội dung hóa đơn

- Tên cửa hàng
- Mã đơn hàng
- Ngày tạo đơn
- Thông tin khách hàng
- Thông tin nhân viên tạo đơn
- Danh sách sản phẩm
- Số lượng
- Đơn giá
- Thành tiền
- Tổng tiền

### API dự kiến

```http
GET /api/orders/{id}/invoice
```

### Công nghệ sử dụng

- Jaspersoft Studio để thiết kế file `.jrxml`
- JasperReports Library để export PDF trong Spring Boot

---

## 6.7. Xử lý bất đồng bộ bằng RabbitMQ

### Mô tả

Sau khi tạo đơn hàng thành công, hệ thống gửi một message vào RabbitMQ. Consumer sẽ nhận message và xử lý tác vụ nền.

### Use case đề xuất

- Ghi log hoạt động tạo đơn hàng
- Giả lập gửi email thông báo đơn hàng
- Xử lý export báo cáo nền nếu mở rộng sau này

### Luồng xử lý

```text
OrderService tạo đơn hàng
→ RabbitTemplate gửi message vào queue
→ @RabbitListener nhận message
→ Consumer xử lý message
→ Ghi log hoặc gửi thông báo
```

### Thành phần chính

| Thành phần | Vai trò |
|---|---|
| Producer | Gửi message khi tạo đơn hàng |
| Queue | Lưu message tạm thời |
| Consumer | Nhận và xử lý message |
| Exchange | Điều hướng message đến queue |
| Routing Key | Xác định message đi vào queue nào |

---

## 7. Thiết kế cơ sở dữ liệu

## 7.1. Danh sách bảng

Tối thiểu hệ thống có các bảng sau:

```text
users
roles
user_roles
products
customers
orders
order_items
activity_logs
```

---

## 7.2. Mô tả bảng

### users

Lưu thông tin tài khoản người dùng.

| Trường | Kiểu dữ liệu gợi ý | Mô tả |
|---|---|---|
| id | BIGINT | Khóa chính |
| username | VARCHAR | Tên đăng nhập |
| password | VARCHAR | Mật khẩu đã mã hóa |
| full_name | VARCHAR | Họ tên |
| email | VARCHAR | Email |
| status | VARCHAR | Trạng thái |
| created_at | DATETIME | Ngày tạo |
| updated_at | DATETIME | Ngày cập nhật |

### roles

Lưu danh sách quyền.

| Trường | Kiểu dữ liệu gợi ý | Mô tả |
|---|---|---|
| id | BIGINT | Khóa chính |
| name | VARCHAR | Tên quyền |

### products

Lưu thông tin sản phẩm.

| Trường | Kiểu dữ liệu gợi ý | Mô tả |
|---|---|---|
| id | BIGINT | Khóa chính |
| code | VARCHAR | Mã sản phẩm |
| name | VARCHAR | Tên sản phẩm |
| description | TEXT | Mô tả |
| price | DECIMAL | Giá bán |
| stock_quantity | INT | Số lượng tồn kho |
| status | VARCHAR | Trạng thái |
| created_at | DATETIME | Ngày tạo |
| updated_at | DATETIME | Ngày cập nhật |

### customers

Lưu thông tin khách hàng.

| Trường | Kiểu dữ liệu gợi ý | Mô tả |
|---|---|---|
| id | BIGINT | Khóa chính |
| full_name | VARCHAR | Họ tên |
| phone | VARCHAR | Số điện thoại |
| email | VARCHAR | Email |
| address | VARCHAR | Địa chỉ |
| status | VARCHAR | Trạng thái |
| created_at | DATETIME | Ngày tạo |
| updated_at | DATETIME | Ngày cập nhật |

### orders

Lưu thông tin đơn hàng.

| Trường | Kiểu dữ liệu gợi ý | Mô tả |
|---|---|---|
| id | BIGINT | Khóa chính |
| order_code | VARCHAR | Mã đơn hàng |
| customer_id | BIGINT | Khách hàng |
| staff_id | BIGINT | Nhân viên tạo đơn |
| total_amount | DECIMAL | Tổng tiền |
| status | VARCHAR | Trạng thái đơn hàng |
| created_at | DATETIME | Ngày tạo |
| updated_at | DATETIME | Ngày cập nhật |

### order_items

Lưu chi tiết sản phẩm trong đơn hàng.

| Trường | Kiểu dữ liệu gợi ý | Mô tả |
|---|---|---|
| id | BIGINT | Khóa chính |
| order_id | BIGINT | Đơn hàng |
| product_id | BIGINT | Sản phẩm |
| quantity | INT | Số lượng |
| unit_price | DECIMAL | Đơn giá tại thời điểm bán |
| total_price | DECIMAL | Thành tiền |

### activity_logs

Lưu log hoạt động của hệ thống.

| Trường | Kiểu dữ liệu gợi ý | Mô tả |
|---|---|---|
| id | BIGINT | Khóa chính |
| action | VARCHAR | Hành động |
| description | TEXT | Mô tả |
| created_at | DATETIME | Thời gian tạo |

---

## 7.3. Quan hệ giữa các bảng

```text
users 1 --- n orders
customers 1 --- n orders
orders 1 --- n order_items
products 1 --- n order_items
users n --- n roles
```

---

## 8. Kiến trúc hệ thống

Dự án sử dụng kiến trúc nhiều tầng phổ biến trong Spring Boot.

```text
Client Angular
    ↓
Controller
    ↓
Service
    ↓
Repository
    ↓
Database
```

### 8.1. Controller Layer

Nhận request từ client, validate dữ liệu đầu vào cơ bản và gọi xuống Service.

Ví dụ:

```text
ProductController
CustomerController
OrderController
ReportController
AuthController
```

### 8.2. Service Layer

Xử lý nghiệp vụ chính của hệ thống.

Ví dụ:

- Kiểm tra tồn kho khi tạo đơn hàng
- Tính tổng tiền đơn hàng
- Cập nhật trạng thái đơn hàng
- Gửi message sau khi tạo đơn
- Gọi Jasper để xuất PDF

### 8.3. Repository Layer

Thao tác với database thông qua Spring Data JPA, JPQL hoặc Native Query.

Ví dụ:

```text
ProductRepository
CustomerRepository
OrderRepository
ReportRepository
```

### 8.4. Database Layer

Lưu trữ dữ liệu người dùng, sản phẩm, khách hàng, đơn hàng và log hoạt động.

---

## 9. Cấu trúc thư mục backend đề xuất

```text
src/main/java/com/hoandev/orderflow
├── config
├── controller
├── service
│   └── impl
├── repository
├── entity
├── dto
│   ├── request
│   └── response
├── exception
├── security
├── mapper
├── report
├── message
└── OrderFlowApplication.java
```

### Ý nghĩa các package

| Package | Vai trò |
|---|---|
| config | Cấu hình Spring, Security, RabbitMQ, Jasper |
| controller | Khai báo REST API |
| service | Interface xử lý nghiệp vụ |
| service.impl | Implement nghiệp vụ |
| repository | Truy vấn database |
| entity | Class ánh xạ bảng database |
| dto.request | Dữ liệu request từ client |
| dto.response | Dữ liệu response trả về client |
| exception | Xử lý lỗi tập trung |
| security | JWT, UserDetails, phân quyền |
| mapper | Chuyển đổi Entity sang DTO |
| report | Xử lý Jasper Report |
| message | Producer/Consumer RabbitMQ |

---

## 10. Công nghệ sử dụng

## 10.1. Backend

- Java 17
- Spring Boot 3.x
- Spring Web
- Spring Data JPA
- Spring Security
- Validation
- Lombok
- JasperReports
- RabbitMQ
- Maven

## 10.2. Frontend

- Angular
- TypeScript
- Angular Router
- HttpClient
- Bootstrap hoặc Angular Material

## 10.3. Database

- SQL Server hoặc MySQL

Nếu đi theo training Java Internship, nên ưu tiên SQL Server vì môi trường doanh nghiệp thường dùng SQL Server.

## 10.4. Tools

- IntelliJ IDEA
- Postman
- DataGrip hoặc SQL Server Management Studio
- Git
- GitHub
- Docker Desktop nếu chạy RabbitMQ bằng container

---

## 11. Cấu trúc frontend Angular đề xuất

```text
src/app
├── core
│   ├── interceptors
│   ├── guards
│   └── services
├── features
│   ├── auth
│   ├── dashboard
│   ├── products
│   ├── customers
│   ├── orders
│   └── reports
├── shared
│   ├── components
│   ├── models
│   └── pipes
└── app-routing.module.ts
```

### Các màn hình chính

- Login
- Dashboard
- Product List
- Product Form
- Customer List
- Customer Form
- Order List
- Create Order
- Order Detail
- Revenue Report

---

## 12. API tổng quan

## 12.1. Auth API

```http
POST /api/auth/login
POST /api/auth/register
```

## 12.2. Product API

```http
GET    /api/products
GET    /api/products/{id}
POST   /api/products
PUT    /api/products/{id}
DELETE /api/products/{id}
```

## 12.3. Customer API

```http
GET    /api/customers
GET    /api/customers/{id}
POST   /api/customers
PUT    /api/customers/{id}
DELETE /api/customers/{id}
```

## 12.4. Order API

```http
GET    /api/orders
GET    /api/orders/{id}
POST   /api/orders
PUT    /api/orders/{id}/status
DELETE /api/orders/{id}
GET    /api/orders/{id}/invoice
```

## 12.5. Report API

```http
GET /api/reports/revenue
GET /api/reports/top-products
```

---

## 13. Kiến thức áp dụng trong dự án

| Nội dung training | Cách áp dụng trong project |
|---|---|
| Algorithm | Xử lý logic tính tổng tiền, kiểm tra tồn kho, luyện HackerRank song song |
| SQL | Thiết kế bảng, JOIN, GROUP BY, báo cáo doanh thu |
| Spring Boot | Xây dựng REST API backend |
| JPA/Hibernate | Entity, Repository, quan hệ bảng, transaction |
| Native Query / Stored Procedure | API báo cáo doanh thu |
| Angular | Xây dựng giao diện quản trị |
| Git | Branch theo từng chức năng, commit rõ ràng |
| Jasper Report | Xuất hóa đơn PDF |
| RabbitMQ/Kafka | Xử lý message sau khi tạo đơn hàng |

---

## 14. Kế hoạch triển khai

## Giai đoạn 1: Khởi tạo dự án

- Tạo project Spring Boot
- Cấu hình database
- Tạo cấu trúc package chuẩn
- Cấu hình Git repository
- Tạo project Angular

## Giai đoạn 2: Xây dựng backend CRUD

- Product CRUD
- Customer CRUD
- Order CRUD
- Validate request
- Exception handling
- Test API bằng Postman

## Giai đoạn 3: Xây dựng nghiệp vụ đơn hàng

- Tạo đơn hàng nhiều sản phẩm
- Kiểm tra tồn kho
- Tính tổng tiền
- Trừ tồn kho khi tạo đơn
- Cộng lại tồn kho khi hủy đơn
- Cập nhật trạng thái đơn hàng

## Giai đoạn 4: Xây dựng frontend Angular

- Login page
- Layout quản trị
- Product management
- Customer management
- Order management
- Create order page
- Report page

## Giai đoạn 5: Tích hợp báo cáo và xử lý nền

- Native Query báo cáo doanh thu
- Jasper Report xuất hóa đơn PDF
- RabbitMQ xử lý message tạo đơn hàng
- Ghi log hoạt động

## Giai đoạn 6: Hoàn thiện project

- Format code
- Xóa code thừa
- Viết README
- Kiểm tra lại Git branch và commit
- Chuẩn bị demo

---

## 15. Git workflow đề xuất

Không push trực tiếp lên `main`.

### Branch chính

```text
main
develop
```

### Branch chức năng

```text
feature/auth
feature/product-management
feature/customer-management
feature/order-management
feature/report
feature/rabbitmq
feature/angular-ui
```

### Commit message mẫu

```text
feat: add product CRUD APIs
feat: implement create order flow
fix: validate product stock before creating order
refactor: separate order business logic into service layer
chore: configure RabbitMQ connection
```

---

## 16. Tiêu chí hoàn thành

Dự án được coi là hoàn thành khi có đủ các tiêu chí sau:

- Backend Spring Boot chạy được
- Frontend Angular gọi được API
- Có database và dữ liệu mẫu
- Có chức năng đăng nhập
- Có CRUD sản phẩm
- Có CRUD khách hàng
- Có tạo đơn hàng
- Có kiểm tra tồn kho
- Có báo cáo doanh thu bằng Native Query hoặc Stored Procedure
- Có xuất hóa đơn PDF bằng Jasper Report
- Có RabbitMQ hoặc Kafka cho ít nhất một use case
- Code được đẩy lên GitHub
- README mô tả rõ cách chạy project
- Người làm giải thích được toàn bộ code chính trong project

---

## 17. Kết luận

OrderFlow Management System là một dự án phù hợp cho mục tiêu Java Intern/Fresher vì phạm vi không quá lớn nhưng vẫn bao phủ nhiều kỹ năng thực tế.

Dự án này giúp người học rèn luyện cách xây dựng một hệ thống web hoàn chỉnh từ backend, frontend, database đến báo cáo và xử lý bất đồng bộ. Nếu hoàn thiện tốt, đây có thể trở thành một project portfolio đủ tốt để trình bày khi phỏng vấn hoặc khi tham gia training tại doanh nghiệp.

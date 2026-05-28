-- Hotel Management System Database Schema v3
-- Images: Unsplash License (free for commercial use) https://unsplash.com/license
-- Re-run this file to reset and re-seed all demo data.

CREATE DATABASE IF NOT EXISTS hotel_reservation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_reservation;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS hotels;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(120) NOT NULL UNIQUE,
    phone         VARCHAR(20),
    password_hash VARCHAR(64)  NOT NULL,
    role          ENUM('Admin','User') NOT NULL DEFAULT 'User',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE hotels (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    hotel_name     VARCHAR(120) NOT NULL,
    location       VARCHAR(200) NOT NULL,
    contact_number VARCHAR(30),
    email          VARCHAR(120),
    description    TEXT,
    facilities     TEXT,
    image          VARCHAR(500),
    star_rating    TINYINT NOT NULL DEFAULT 5,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE rooms (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id        INT NOT NULL,
    room_number     VARCHAR(20)  NOT NULL UNIQUE,
    room_type       VARCHAR(80)  NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    capacity        INT NOT NULL DEFAULT 2,
    status          ENUM('Available','Booked','Maintenance') NOT NULL DEFAULT 'Available',
    description     TEXT,
    image           VARCHAR(500),
    bed_type        VARCHAR(80),
    room_size       VARCHAR(20),
    -- Comma-separated Unsplash gallery URLs (3 extra photos)
    gallery         TEXT,
    -- Comma-separated facility labels shown on room cards
    facilities      TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_room_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

CREATE TABLE reservations (
    id                     INT AUTO_INCREMENT PRIMARY KEY,
    user_id                INT NOT NULL,
    room_id                INT NOT NULL,
    check_in               DATE NOT NULL,
    check_out              DATE NOT NULL,
    number_of_guests       INT NOT NULL DEFAULT 1,
    status                 ENUM('Pending','Confirmed','Cancelled') NOT NULL DEFAULT 'Pending',
    -- Guest contact details (pre-filled from user account, editable on form)
    first_name             VARCHAR(60),
    last_name              VARCHAR(60),
    phone                  VARCHAR(30),
    country                VARCHAR(80) DEFAULT 'Sri Lanka',
    special_requests       TEXT,
    booking_for            VARCHAR(20) DEFAULT 'Self',
    traveling_for_work     TINYINT(1)  DEFAULT 0,
    paperless_confirmation TINYINT(1)  DEFAULT 0,
    created_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_res_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_res_room FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE payments (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    user_id        INT NOT NULL,
    amount         DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(40)   NOT NULL,
    payment_date   DATE          NOT NULL,
    status         ENUM('Pending','Paid','Failed','Refunded') NOT NULL DEFAULT 'Pending',
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pay_res  FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
    CONSTRAINT fk_pay_user FOREIGN KEY (user_id)        REFERENCES users(id)         ON DELETE CASCADE
);

CREATE TABLE feedback (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT NOT NULL,
    reservation_id INT NOT NULL,
    rating         INT NOT NULL,
    comment        TEXT,
    feedback_date  DATE NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT fk_fb_user FOREIGN KEY (user_id)        REFERENCES users(id)         ON DELETE CASCADE,
    CONSTRAINT fk_fb_res  FOREIGN KEY (reservation_id) REFERENCES reservations(id)  ON DELETE CASCADE
);

-- ─────────────────────────────────────────────────────────────
-- USERS
-- ─────────────────────────────────────────────────────────────
INSERT INTO users (name, email, phone, password_hash, role) VALUES
('System Admin', 'admin@hotel.com', '0710000000', SHA2('admin123',256), 'Admin'),
('Lakvin Perera', 'user@hotel.com',  '0712345678', SHA2('user123', 256), 'User'),
('Anita Silva',  'anita@example.com','0771122334', SHA2('user123', 256), 'User');

-- ─────────────────────────────────────────────────────────────
-- HOTELS
-- ─────────────────────────────────────────────────────────────
INSERT INTO hotels (hotel_name, location, contact_number, email, description, facilities, image, star_rating) VALUES

('Cinnamon Grand Colombo',
 'Sir James Peiris Mawatha, Colombo 02, Sri Lanka',
 '+94 11 243 7437', 'reservations@cinnamongrand.com',
 'A landmark 5-star city hotel in the heart of Colombo offering world-class dining, a rooftop infinity pool, state-of-the-art conference facilities, and unrivalled views of the Indian Ocean. The perfect base for business travellers and leisure guests exploring the vibrant capital.',
 'Rooftop infinity pool, 10 restaurants & bars, Spa & wellness centre, Fitness centre, Business centre, Valet parking, 24-hour concierge, Airport limousine',
 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1400&q=80', 5),

('Earl''s Regency Hotel',
 'Tennekumbura, Kandy, Sri Lanka',
 '+94 81 233 0000', 'reservations@earls.lk',
 'Nestled on a hilltop overlooking the lush Kandy Valley, Earl''s Regency is a luxury retreat that blends colonial elegance with modern comforts. Guests enjoy panoramic views, a stunning infinity pool, and easy access to Kandy''s UNESCO World Heritage sites.',
 'Infinity pool with valley views, Spa & Ayurveda centre, Three restaurants, Ballroom, Tennis court, Hiking trails, Children''s play area, Tour desk',
 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?auto=format&fit=crop&w=1400&q=80', 5),

('Fort Bazaar',
 '26 Church Street, Galle Fort, Sri Lanka',
 '+94 91 223 0330', 'info@fortbazaar.com',
 'A boutique luxury hotel housed in a lovingly restored 17th-century Dutch colonial mansion within the UNESCO-listed Galle Fort. Fort Bazaar offers just 17 individually designed rooms, a rooftop plunge pool, and an award-winning restaurant celebrating Sri Lankan cuisine.',
 'Rooftop plunge pool, Boutique spa, Fort-view restaurant, Heritage library lounge, Cycling, Curated cultural tours, Complimentary fort walking tour',
 'https://images.unsplash.com/photo-1590381105924-c72589b9ef3f?auto=format&fit=crop&w=1400&q=80', 5),

('The Grand Hotel',
 'Grand Hotel Road, Nuwara Eliya, Sri Lanka',
 '+94 52 222 2881', 'reservations@grandhotelnuwaraeliya.com',
 'Built in 1891 as the residence of Sir Edward Barnes, Governor of Ceylon, The Grand Hotel is a magnificent colonial heritage property set amidst rolling tea estates in Sri Lanka''s "Little England". It retains its Victorian grandeur with period furniture, an English pub, and manicured lawns.',
 'Heritage billiards room, English Pub, Indoor heated pool, Lawn tennis, Croquet, Fine dining, Afternoon tea, Snooker, Fireside lounge',
 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=1400&q=80', 4),

('98 Acres Resort & Spa',
 'Ella, Badulla District, Uva Province, Sri Lanka',
 '+94 57 222 8999', 'info@98acres.com',
 'Perched on 98 acres of working tea estate on a misty hillside above Ella, this boutique resort offers breathtaking views of the Ella Gap, the iconic Little Adam''s Peak, and endless rolling green valleys. With an infinity pool that seems to merge with the sky and world-class Ayurvedic spa, it is one of Sri Lanka''s most spectacular retreats.',
 'Infinity pool overlooking Ella Gap, Ayurveda spa, Farm-to-table restaurant, Tea estate walks, Mountain biking, Yoga pavilion, Stargazing deck, Complimentary transfers',
 'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?auto=format&fit=crop&w=1400&q=80', 5);

-- ─────────────────────────────────────────────────────────────
-- ROOMS  (hotel_id follows INSERT order above: 1–5)
-- gallery = 3 comma-separated Unsplash JPG URLs
-- facilities = comma-separated room amenities
-- ─────────────────────────────────────────────────────────────
INSERT INTO rooms (hotel_id, room_number, room_type, price_per_night, capacity, status, description, image, bed_type, room_size, gallery, facilities) VALUES

-- ── Cinnamon Grand Colombo (1) ────────────────────────────────────────────
(1,'CG-101','Superior Room',
 35000.00, 2, 'Available',
 'Elegantly appointed 32 m² Superior Room featuring a king-size bed, floor-to-ceiling city-view windows, marble bathroom with rain shower, complimentary high-speed Wi-Fi, and a fully stocked minibar. Ideal for business and leisure travellers.',
 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=900&q=80',
 '1 King Bed', '32 m²',
 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Air Conditioning, Flat-screen TV, Mini Bar, Safe, Tea & Coffee Maker, Rain Shower'),

(1,'CG-201','Deluxe Ocean View',
 52000.00, 2, 'Available',
 'A stunning 45 m² Deluxe Room with panoramic Indian Ocean views, a plush king-size bed, walk-in wardrobe, deep-soak bathtub plus separate rain shower, and a private balcony. Includes turndown service and premium Dilmah tea selection.',
 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=900&q=80',
 '1 King Bed', '45 m²',
 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1619468129361-605ebea04b44?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Air Conditioning, Ocean-View Balcony, Flat-screen TV, Mini Bar, Bathtub, Rain Shower, Safe'),

(1,'CG-301','Club Suite',
 89000.00, 3, 'Available',
 'Opulent 80 m² Club Suite featuring a separate living room, private dining area, two marble bathrooms, and exclusive Club Lounge access with complimentary breakfast, all-day snacks, and evening cocktails. Sweeping city and ocean views.',
 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=900&q=80',
 '1 King Bed + Sofa Bed', '80 m²',
 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1631049552057-403cdb8f0658?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1596436889106-be35e843f974?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Club Lounge Access, Breakfast Included, Air Conditioning, Jacuzzi, Butler Service, Flat-screen TV'),

(1,'CG-401','Presidential Suite',
 180000.00, 4, 'Available',
 'The pinnacle of Colombo luxury — a 200 m² Presidential Suite with a private terrace, dining room for six, home theatre, butler pantry, and two en-suite master bedrooms. Dedicated butler, airport transfer, and spa welcome credit included.',
 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?auto=format&fit=crop&w=900&q=80',
 '2 King Beds', '200 m²',
 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1619468129361-605ebea04b44?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Private Terrace, Butler Service, Home Theatre, Airport Transfer, Spa Credit, Breakfast Included, Jacuzzi'),

-- ── Earl''s Regency Hotel (2) ─────────────────────────────────────────────
(2,'ER-101','Superior Valley View',
 28000.00, 2, 'Available',
 'Cosy 30 m² Superior Room with a private balcony framing the verdant Kandy Valley. Furnished with a queen-size bed, en-suite bathroom with local stone accents, and traditional Kandyan décor. Complimentary Wi-Fi and tea/coffee amenities included.',
 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=900&q=80',
 '1 Queen Bed', '30 m²',
 'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Air Conditioning, Valley-View Balcony, Flat-screen TV, Tea & Coffee Maker, Safe'),

(2,'ER-201','Deluxe Pool Access',
 45000.00, 2, 'Available',
 'Step directly from your private terrace into the celebrated infinity pool. This 42 m² Deluxe Room combines contemporary design with Sri Lankan textiles, featuring a king bed, open-air rain shower, and sweeping hillside vistas.',
 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=900&q=80',
 '1 King Bed', '42 m²',
 'https://images.unsplash.com/photo-1619468129361-605ebea04b44?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1596436889106-be35e843f974?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Direct Pool Access, Air Conditioning, Rain Shower, Flat-screen TV, Mini Bar, Safe'),

(2,'ER-302','Kandy View Suite',
 72000.00, 3, 'Booked',
 'A spacious 65 m² suite with a wraparound balcony offering 180° views across the Kandy Valley. Features a separate living room, king bed, Jacuzzi bath, and personalised butler service for an unforgettable hill-country escape.',
 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=900&q=80',
 '1 King Bed + Sofa', '65 m²',
 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1631049552057-403cdb8f0658?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Wrap-around Balcony, Butler Service, Jacuzzi, Flat-screen TV, Mini Bar, Air Conditioning'),

-- ── Fort Bazaar (3) ───────────────────────────────────────────────────────
(3,'FB-101','Colonial Courtyard Room',
 22000.00, 2, 'Available',
 'A beautifully restored 28 m² room within the 17th-century Dutch mansion, featuring exposed brick walls, antique teak furniture, a four-poster bed with handwoven linen, and a colonial-style en-suite bathroom. Overlooks the secluded courtyard garden.',
 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?auto=format&fit=crop&w=900&q=80',
 '1 Four-Poster King Bed', '28 m²',
 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Courtyard View, Air Conditioning, Flat-screen TV, Heritage Décor, Tea & Coffee Maker'),

(3,'FB-201','Fort View Room',
 32000.00, 2, 'Available',
 'Charming 35 m² first-floor room with direct views across the historic Galle Fort ramparts and the Indian Ocean beyond. Period furnishings, ceiling fan, en-suite bathroom with hand-painted tiles, and a reading nook.',
 'https://images.unsplash.com/photo-1586105251261-72a756497a11?auto=format&fit=crop&w=900&q=80',
 '1 King Bed', '35 m²',
 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Fort & Ocean View, Ceiling Fan, Air Conditioning, Heritage Décor, Safe'),

(3,'FB-301','Rooftop Plunge Suite',
 58000.00, 2, 'Available',
 'Jewel of Fort Bazaar — a 50 m² suite with exclusive access to a private rooftop plunge pool overlooking the lighthouse and ocean. Decorated with Galle antiques, this suite includes a king bed, outdoor daybed, and bespoke Ceylonese breakfast service.',
 'https://images.unsplash.com/photo-1540541338537-1220-cc3e79bc878?auto=format&fit=crop&w=900&q=80',
 '1 King Bed + Day Bed', '50 m²',
 'https://images.unsplash.com/photo-1619468129361-605ebea04b44?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1596436889106-be35e843f974?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Private Plunge Pool, Breakfast Included, Air Conditioning, Flat-screen TV, Outdoor Daybed'),

-- ── The Grand Hotel (4) ───────────────────────────────────────────────────
(4,'GH-101','Heritage Standard Room',
 18000.00, 2, 'Available',
 'Step back in time in a 30 m² Heritage Standard Room furnished with original Victorian furniture, patterned carpets, a brass bed, and period-style bathroom fixtures. Open the bay windows to breathe in the crisp mountain air of Nuwara Eliya.',
 'https://images.unsplash.com/photo-1568495248636-6432b97bd949?auto=format&fit=crop&w=900&q=80',
 '1 Double Bed', '30 m²',
 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Garden View, Victorian Heritage Décor, Tea & Coffee Maker, Safe'),

(4,'GH-201','Colonial Superior',
 27000.00, 2, 'Available',
 'A generously sized 42 m² Colonial Superior Room with a fireplace, four-poster bed dressed in fine linen, and a deep Victorian clawfoot bathtub. Garden views of the manicured lawns are complemented by afternoon tea delivered to your room.',
 'https://images.unsplash.com/photo-1595576508898-0ad5c879a061?auto=format&fit=crop&w=900&q=80',
 '1 Four-Poster King Bed', '42 m²',
 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Fireplace, Clawfoot Bathtub, Afternoon Tea, Garden View, Heritage Décor, Safe'),

(4,'GH-301','Grand Suite',
 55000.00, 4, 'Available',
 'The grand centrepiece of the hotel — a 90 m² suite with a private sitting room, original oil paintings, two Queen-size beds, and panoramic views across the lawns and racetrack. English butler service and complimentary afternoon tea included.',
 'https://images.unsplash.com/photo-1602872030219-ad2b9a54315c?auto=format&fit=crop&w=900&q=80',
 '2 Queen Beds', '90 m²',
 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1596436889106-be35e843f974?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1619468129361-605ebea04b44?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Butler Service, Afternoon Tea, Sitting Room, Fireplace, Panoramic View, Safe'),

-- ── 98 Acres Resort & Spa (5) ─────────────────────────────────────────────
(5,'AA-101','Garden Chalet',
 38000.00, 2, 'Available',
 'A private 40 m² chalet nestled among tea bushes, with a king bed, outdoor rain shower, and a private veranda with hammock chair. Wake up to sweeping views of the Ella Gap and enjoy complimentary estate tea freshly picked that morning.',
 'https://images.unsplash.com/photo-1449158743715-0a90ebb6d2d8?auto=format&fit=crop&w=900&q=80',
 '1 King Bed', '40 m²',
 'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Private Veranda, Outdoor Rain Shower, Hammock Chair, Tea Estate View, Tea & Coffee Maker'),

(5,'AA-201','Valley View Suite',
 62000.00, 2, 'Available',
 'A breathtaking 55 m² suite perched at the estate''s highest point with floor-to-ceiling glass walls framing the valley panorama. Features a freestanding stone bathtub, outdoor deck with sunbeds, and premium Ella Spice amenity collection.',
 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=900&q=80',
 '1 King Bed', '55 m²',
 'https://images.unsplash.com/photo-1619468129361-605ebea04b44?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1596436889106-be35e843f974?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Glass-Wall Valley View, Stone Freestanding Bathtub, Outdoor Deck, Sunbeds, Air Conditioning'),

(5,'AA-302','Infinity Pool Villa',
 98000.00, 3, 'Available',
 'An exclusive 75 m² private villa with a dedicated plunge pool blending seamlessly with the estate''s signature infinity pool, offering uninterrupted views of Little Adam''s Peak. Includes a private butler, in-villa Ayurvedic treatment, and sunrise guided hike.',
 'https://images.unsplash.com/photo-1610641818989-c2051b5e2cfd?auto=format&fit=crop&w=900&q=80',
 '1 King Bed + Day Bed', '75 m²',
 'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1560185007-cde436f6a4d0?auto=format&fit=crop&w=600&q=80,https://images.unsplash.com/photo-1631049552057-403cdb8f0658?auto=format&fit=crop&w=600&q=80',
 'Free Wi-Fi, Private Plunge Pool, Butler Service, Ayurveda Treatment, Sunrise Hike, Outdoor Day Bed, Breakfast Included');

-- ─────────────────────────────────────────────────────────────
-- SAMPLE DATA
-- ─────────────────────────────────────────────────────────────
INSERT INTO reservations (user_id, room_id, check_in, check_out, number_of_guests, status, first_name, last_name, phone, country, booking_for) VALUES
(2, 1, '2026-05-20', '2026-05-23', 2, 'Confirmed', 'Lakvin', 'Perera', '+94712345678', 'Sri Lanka', 'Self');

INSERT INTO payments (reservation_id, user_id, amount, payment_method, payment_date, status) VALUES
(1, 2, 105000.00, 'Card', '2026-05-14', 'Paid');

INSERT INTO feedback (user_id, reservation_id, rating, comment, feedback_date) VALUES
(2, 1, 5, 'An absolutely spectacular stay at Cinnamon Grand. The ocean views were breathtaking and the service impeccable.', '2026-05-23');

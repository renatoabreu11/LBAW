-- To use when the postgres database is out of sync

SELECT setval('admin_id_seq', (SELECT MAX(id) FROM admin)+1);
SELECT setval('answer_id_seq', (SELECT MAX(id) FROM answer)+1);
SELECT setval('answer_report_id_seq', (SELECT MAX(id) FROM answer_report)+1);
SELECT setval('auction_id_seq', (SELECT MAX(id) FROM auction)+1);
SELECT setval('auction_report_id_seq', (SELECT MAX(id) FROM auction_report)+1);
SELECT setval('bid_id_seq', (SELECT MAX(id) FROM bid)+1);
SELECT setval('city_id_seq', (SELECT MAX(id) FROM city)+1);
SELECT setval('country_id_seq', (SELECT MAX(id) FROM country)+1);
SELECT setval('image_id_seq', (SELECT MAX(id) FROM image)+1);
SELECT setval('location_id_seq', (SELECT MAX(id) FROM location)+1);
SELECT setval('notification_id_seq', (SELECT MAX(id) FROM notification)+1);
SELECT setval('product_id_seq', (SELECT MAX(id) FROM product)+1);
SELECT setval('question_id_seq', (SELECT MAX(id) FROM question)+1);
SELECT setval('question_report_id_seq', (SELECT MAX(id) FROM question_report)+1);
SELECT setval('review_id_seq', (SELECT MAX(id) FROM review)+1);
SELECT setval('review_report_id_seq', (SELECT MAX(id) FROM review_report)+1);
SELECT setval('user_id_seq', (SELECT MAX(id) FROM "user")+1);
SELECT setval('user_report_id_seq', (SELECT MAX(id) FROM user_report)+1);

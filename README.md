# exam_database

Constraints

PRIMARY KEY
FERIEGN KEY -- linking data
NOT NULL -- column cant have null value
UNIQUE -- allows only for unique value
CHECK -- only allows certain values
DEFAULT
COLLATE
DELETE ON CASCADE




GRAPH COMMANDS

get the person from 3..3 who like item 2 with more than 4 rating

/* LET user_one = DOCUMENT("people/One") */
FOR person IN people
    FILTER person.name == "One"
    FOR v,e,p IN 3..3 OUTBOUND person people_friends_with_people
        FOR item,e1,p1 IN 1..1 OUTBOUND v people_likes_items
            FILTER item.name == "I2"
                FILTER e1.rating > 4
                RETURN v


3..3 show the person that likes item 2 with more than 2 in ratings cousin

FOR person IN people
    FILTER person.name == "One"
    FOR v,e,p IN 3..3 OUTBOUND person people_friends_with_people
        FOR item,e1,p1 IN 1..1 OUTBOUND v people_likes_items
            FILTER item.name == "I2"
                FILTER e1.rating > 2
                    FOR v2,e2,p2 IN 1..1 ANY v people_related_to_people
                        FILTER e2.relation == "cousin"
                        RETURN v2
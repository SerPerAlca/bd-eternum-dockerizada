SET NAMES 'utf8mb4';
SET CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS core
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- ==========================================================
-- 1. SEGURIDAD Y USUARIOS (Aislamiento de Core)
-- ==========================================================
-- Crear el usuario específico para el microservicio CORE
CREATE USER IF NOT EXISTS 'user_core'@'%' IDENTIFIED BY 'pass_core_123';

-- Dar permisos solo sobre la base de datos 'core'
GRANT ALL PRIVILEGES ON core.* TO 'user_core'@'%';
FLUSH PRIVILEGES;


USE core;

-- =====================
-- CATÁLOGOS BÁSICOS
-- =====================
CREATE TABLE SKILLS_TYPE (
  CODE VARCHAR(4) PRIMARY KEY,
  DESCRIPTION VARCHAR(255) NOT NULL
);

CREATE TABLE SPECIES_TYPE (
  CODE VARCHAR(4) PRIMARY KEY,
  DESCRIPTION TEXT NOT NULL
);

CREATE TABLE WEAPONS_TYPE (
  CODE VARCHAR(4) PRIMARY KEY,
  DESCRIPTION VARCHAR(255) NOT NULL
);

CREATE TABLE ARMORS_TYPE (
  CODE VARCHAR(4) PRIMARY KEY,
  DESCRIPTION VARCHAR(255) NOT NULL
);

CREATE TABLE ITEMS_TYPE (
  CODE VARCHAR(4) PRIMARY KEY,
  DESCRIPTION VARCHAR(255) NOT NULL
);

CREATE TABLE RARITY_LEVELS (
  CODE VARCHAR(4) PRIMARY KEY,
  DESCRIPTION VARCHAR(255) NOT NULL,
  COLOR_HEX VARCHAR(7) NOT NULL,
  DROP_RATE DECIMAL(5,4) NOT NULL
);

CREATE TABLE PRODUCTS_TYPE (
  CODE VARCHAR(4) PRIMARY KEY, -- 'WEAP', 'ARMO', 'ITEM'
  DESCRIPTION VARCHAR(255) NOT NULL
);

CREATE TABLE STORES_TYPE (
  CODE VARCHAR(4) PRIMARY KEY,
  DESCRIPTION VARCHAR(255) NOT NULL
);

CREATE TABLE LOCATIONS_TYPE (
  CODE VARCHAR(4) PRIMARY KEY,
  DESCRIPTION VARCHAR(255) NOT NULL
);

CREATE TABLE CITIES_TYPE (
  CODE VARCHAR(4) PRIMARY KEY,
  DESCRIPTION VARCHAR(255) NOT NULL
);

-- Tabla base para todos los objetos
CREATE TABLE PRODUCTS (
  ID BIGINT AUTO_INCREMENT PRIMARY KEY,
  PRODUCT_TYPE VARCHAR(4) NOT NULL,
  CONSTRAINT fk_prod_type FOREIGN KEY (PRODUCT_TYPE) REFERENCES PRODUCTS_TYPE(CODE)
);

-- =====================
-- SKILLS
-- =====================
CREATE TABLE SKILLS (
  ID BIGINT AUTO_INCREMENT PRIMARY KEY,
  SKILL_TYPE VARCHAR(4) NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  DESCRIPTION TEXT NOT NULL,
  FOREIGN KEY (SKILL_TYPE) REFERENCES SKILLS_TYPE(CODE)
);

CREATE TABLE BASE_STATS (
  ID BIGINT AUTO_INCREMENT PRIMARY KEY,
  PHYSICAL_ATTACK INT DEFAULT 0,
  MAGIC_ATTACK INT DEFAULT 0,
  EVASION INT DEFAULT 0,
  MANA INT DEFAULT 0,
  VITALITY INT DEFAULT 0,
  PHYSICAL_DEFENSE INT DEFAULT 0,
  MAGIC_DEFENSE INT DEFAULT 0,
  MOVEMENT INT DEFAULT 0
) ENGINE=InnoDB;

-- =====================
-- HEROES
-- =====================
CREATE TABLE HEROES (
  CODE VARCHAR(4) PRIMARY KEY,
  SPECIES_TYPE VARCHAR(4) NOT NULL,
  BASE_STATS_ID BIGINT NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  ALIAS VARCHAR(255),
  DESCRIPTION TEXT NOT NULL,
  PORTRAIT_IMAGE_URL VARCHAR(255) NOT NULL,
  CONSTRAINT fk_hero_species FOREIGN KEY (SPECIES_TYPE) REFERENCES SPECIES_TYPE(CODE),
  CONSTRAINT fk_hero_stats FOREIGN KEY (BASE_STATS_ID) REFERENCES BASE_STATS(ID)
) ENGINE=InnoDB;

CREATE TABLE SKILLS_HEROES (
  SKILL_ID BIGINT NOT NULL,
  HEROE_CODE VARCHAR(4) NOT NULL,
  UNLOCK_LEVEL INT NOT NULL,
  MANA_COST INT NOT NULL,
  PRIMARY KEY (SKILL_ID, HEROE_CODE),
  FOREIGN KEY (SKILL_ID) REFERENCES SKILLS(ID),
  FOREIGN KEY (HEROE_CODE) REFERENCES HEROES(CODE)
);

-- Tabla para definir qué tipos de armas puede usar cada héroe
CREATE TABLE HERO_SKILL_WEAPONS (
  WEAPON_TYPE_CODE VARCHAR(4) NOT NULL,
  HEROE_CODE VARCHAR(4) NOT NULL,
  PRIMARY KEY (WEAPON_TYPE_CODE, HEROE_CODE),
  CONSTRAINT fk_hsw_weapon_type FOREIGN KEY (WEAPON_TYPE_CODE) REFERENCES WEAPONS_TYPE(CODE),
  CONSTRAINT fk_hsw_hero_code FOREIGN KEY (HEROE_CODE) REFERENCES HEROES(CODE)
) ENGINE=InnoDB;

-- Tabla para definir qué tipos de armaduras puede usar cada héroe
CREATE TABLE HERO_SKILL_ARMORS (
  ARMOR_TYPE_CODE VARCHAR(4) NOT NULL,
  HEROE_CODE VARCHAR(4) NOT NULL,
  PRIMARY KEY (ARMOR_TYPE_CODE, HEROE_CODE),
  CONSTRAINT fk_hsa_armor_type FOREIGN KEY (ARMOR_TYPE_CODE) REFERENCES ARMORS_TYPE(CODE),
  CONSTRAINT fk_hsa_hero_code FOREIGN KEY (HEROE_CODE) REFERENCES HEROES(CODE)
) ENGINE=InnoDB;

-- =====================
-- ENEMIES
-- =====================
CREATE TABLE ENEMIES (
  ID BIGINT AUTO_INCREMENT PRIMARY KEY,
  SPECIES_TYPE VARCHAR(4) NOT NULL,
  BASE_STATS_ID BIGINT NOT NULL,
  DESCRIPTION TEXT NOT NULL,
  IS_BOSS TINYINT(1) NOT NULL,
  REWARD VARCHAR(255),
  PORTRAIT_IMAGE_URL VARCHAR(255) NOT NULL,
  CONSTRAINT fk_enemy_species FOREIGN KEY (SPECIES_TYPE) REFERENCES SPECIES_TYPE(CODE),
  CONSTRAINT fk_enemy_stats FOREIGN KEY (BASE_STATS_ID) REFERENCES BASE_STATS(ID)
) ENGINE=InnoDB;

CREATE TABLE SKILLS_ENEMIES (
  SKILL_ID BIGINT NOT NULL,
  ENEMY_ID BIGINT NOT NULL,
  USE_LIMIT INT NOT NULL,
  PRIMARY KEY (SKILL_ID, ENEMY_ID),
  FOREIGN KEY (SKILL_ID) REFERENCES SKILLS(ID),
  FOREIGN KEY (ENEMY_ID) REFERENCES ENEMIES(ID)
);

-- =====================
-- EQUIPAMIENTO
-- =====================
CREATE TABLE ARMORS (
  ID BIGINT PRIMARY KEY,
  RARITY VARCHAR(4) NOT NULL,
  ARMOR_TYPE VARCHAR(4) NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  DESCRIPTION TEXT NOT NULL,
  PHYSICAL_DEFENSE INT,
  MAGIC_DEFENSE INT,
  UNLOCK_LEVEL INT NOT NULL,
  WEIGHT INT NOT NULL,
  SPECIAL_CONDITION VARCHAR(255),
  FOREIGN KEY (RARITY) REFERENCES RARITY_LEVELS(CODE),
  FOREIGN KEY (ARMOR_TYPE) REFERENCES ARMORS_TYPE(CODE),
  CONSTRAINT fk_armor_product FOREIGN KEY (ID) REFERENCES PRODUCTS(ID)
);

CREATE TABLE WEAPONS (
  ID BIGINT PRIMARY KEY,
  RARITY VARCHAR(4) NOT NULL,
  WEAPON_TYPE VARCHAR(4) NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  DESCRIPTION TEXT NOT NULL,
  PHYSICAL_ATTACK INT,
  MAGIC_ATTACK INT,
  UNLOCK_LEVEL INT NOT NULL,
  WEIGHT INT NOT NULL,
  SPECIAL_CONDITION VARCHAR(255),
  FOREIGN KEY (RARITY) REFERENCES RARITY_LEVELS(CODE),
  FOREIGN KEY (WEAPON_TYPE) REFERENCES WEAPONS_TYPE(CODE),
  CONSTRAINT fk_weapon_product FOREIGN KEY (ID) REFERENCES PRODUCTS(ID)
);

-- =====================
-- ITEMS
-- =====================
CREATE TABLE ITEMS (
  ID BIGINT PRIMARY KEY,
  ITEM_TYPE VARCHAR(4) NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  DESCRIPTION TEXT NOT NULL,
  WEIGHT INT NOT NULL,
  FOREIGN KEY (ITEM_TYPE) REFERENCES ITEMS_TYPE(CODE),
  CONSTRAINT fk_item_product FOREIGN KEY (ID) REFERENCES PRODUCTS(ID)
);

-- ==========================================================
-- WORLD / MAP / NAVIGATION
-- ==========================================================

-- 1. Definición de Regiones
CREATE TABLE REGIONS (
  ID BIGINT AUTO_INCREMENT PRIMARY KEY,
  NAME VARCHAR(255) NOT NULL,
  DESCRIPTION TEXT NOT NULL,
  MIN_LEVEL INT NOT NULL
) ENGINE=InnoDB;

-- 2. Ciudades vinculadas a regiones
CREATE TABLE CITIES (
  ID BIGINT AUTO_INCREMENT PRIMARY KEY,
  REGION_ID BIGINT NOT NULL,
  CITIES_TYPE VARCHAR(4) NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  DESCRIPTION TEXT NOT NULL,
  CONSTRAINT fk_city_region FOREIGN KEY (REGION_ID) REFERENCES REGIONS(ID),
  CONSTRAINT fk_city_type FOREIGN KEY (CITIES_TYPE) REFERENCES CITIES_TYPE(CODE)
) ENGINE=InnoDB;

-- 3. Localizaciones específicas
CREATE TABLE LOCATIONS (
  ID BIGINT AUTO_INCREMENT PRIMARY KEY,
  LOCATION_TYPE VARCHAR(4) NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  DESCRIPTION TEXT,
  CONSTRAINT fk_location_type FOREIGN KEY (LOCATION_TYPE) REFERENCES LOCATIONS_TYPE(CODE)
) ENGINE=InnoDB;

-- 4. Sistema de Nodos (Grafo de navegación)
CREATE TABLE NODES_CONNECTIONS (
  ID BIGINT AUTO_INCREMENT PRIMARY KEY,
  NAME VARCHAR(40),
  UP_NODE_ID BIGINT,
  UP_DISTANCE INT,
  RIGHT_NODE_ID BIGINT,
  RIGHT_DISTANCE INT,
  DOWN_NODE_ID BIGINT,
  DOWN_DISTANCE INT,
  LEFT_NODE_ID BIGINT,
  LEFT_DISTANCE INT,
  -- Claves foráneas que apuntan a la propia tabla para navegación
  CONSTRAINT fk_node_up FOREIGN KEY (UP_NODE_ID) REFERENCES NODES_CONNECTIONS(ID),
  CONSTRAINT fk_node_right FOREIGN KEY (RIGHT_NODE_ID) REFERENCES NODES_CONNECTIONS(ID),
  CONSTRAINT fk_node_down FOREIGN KEY (DOWN_NODE_ID) REFERENCES NODES_CONNECTIONS(ID),
  CONSTRAINT fk_node_left FOREIGN KEY (LEFT_NODE_ID) REFERENCES NODES_CONNECTIONS(ID)
) ENGINE=InnoDB;

-- 5. Vinculación Nodo con Localización
CREATE TABLE WORLD_NODES (
  NODE_ID BIGINT NOT NULL,
  LOCATION_ID BIGINT NOT NULL,
  PRIMARY KEY (NODE_ID, LOCATION_ID),
  CONSTRAINT fk_world_node FOREIGN KEY (NODE_ID) REFERENCES NODES_CONNECTIONS(ID),
  CONSTRAINT fk_world_location FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS(ID)
) ENGINE=InnoDB;

-- =====================
-- STORES
-- =====================


CREATE TABLE STORES (
  ID BIGINT AUTO_INCREMENT PRIMARY KEY,
  LOCATION_ID BIGINT NOT NULL,
  STORE_TYPE VARCHAR(4) NOT NULL,
  GOLD_LIMIT INT NOT NULL,
  FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS(ID),
  FOREIGN KEY (STORE_TYPE) REFERENCES STORES_TYPE(CODE)
);

CREATE TABLE STORES_INVENTORIES (
  ID BIGINT AUTO_INCREMENT PRIMARY KEY,
  STORE_ID BIGINT NOT NULL,
  PRODUCT_ID BIGINT NOT NULL,
  PRICE DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (STORE_ID) REFERENCES STORES(ID),
  FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(ID)
);


-- ==========================================================
-- INSERCIÓN DE DATOS (Ordenado por dependencias)
-- ==========================================================

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO core.HEROES
(CODE, SPECIES_TYPE, BASE_STATS_ID, NAME, ALIAS, DESCRIPTION, PORTRAIT_IMAGE_URL)
VALUES('ELIA', 'SYLV', 4, 'ELIA SERETHIAL', 'La Rastreadora', 'Elia nació bajo las raíces del Árbol Padre, en el corazón de Sylvanthalas, la misma noche del Último Crepúsculo, cuando la luz y la sombra compartieron el cielo por última vez. Los ancianos del bosque murmuraron que Arenius había posado su mirada sobre ella, pues ningún elfo recordaba un nacimiento ocurrido en hora tan incierta. Desde entonces, Elia fue observada con respeto… y con temor. \\n\\n Fue también una de las pocas sylvantha que afirmaron haber visto a un espíritu bestia y vivido para contarlo. Aún era una niña cuando una manda de lobos orcos se adentró en lo profundo del bosque. Cercada y sin escape, la muerte ya le respiraba encima cuando un oso emergió de la luz, sólido y etéreo a la vez, y desgarró a las criaturas hasta ahuyentarlas. Aquella noche, algo antiguo despertó en Elia. El vínculo con las bestias le fue concedido, y desde entonces comprendió a los animales del bosque como si compartieran un mismo latido. \\n\\n Con los años, su amor por Sylvanthalas creció tanto como su letalidad. Dominó el arco con una destreza poco común incluso entre los suyos: sus disparos eran rápidos como el pensamiento y certeros como un juramento antiguo. No erraba. No dudaba. Por ello fue nombrada Rastreadora, y su vida quedó consagrada a proteger el bosque y dar caza a todo aquello que osara quebrar su paz. \\n\\n Pero la oscuridad no respeta fronteras sagradas. Con el paso del tiempo, criaturas corruptas comenzaron a arrastrarse cada vez más profundo entre las raíces y los claros. Los rastros eran demasiados, y el silencio del bosque se volvió tenso, expectante. Cuando recibió la orden de investigar el origen de aquel mal, Elia comprendió que la caza que se avecinaba no sería como las anteriores. \\n\\n Armada con su arco y una daga desgastada por el uso, abandonó por primera vez el bosque que la había visto nacer. Marchó siguiendo un rastro que olía a muerte y corrupción, consciente de que la presa que buscaba quizá no pudiera ser abatida… y de que el precio de la caza podría ser su propia vida.', 'NULL');
INSERT INTO core.HEROES
(CODE, SPECIES_TYPE, BASE_STATS_ID, NAME, ALIAS, DESCRIPTION, PORTRAIT_IMAGE_URL)
VALUES('JHON', 'HUMA', 1, 'JHON ALIAS', 'El Cazador de Ceniza', 'El fuego no lo tomó todo, aunque Dios sabe que lo intentó. \\n\\n Dicen que, en la ciudad de su infancia, el humo ocultó las estrellas la noche en que los lobos rompieron sus cadenas. No eran lobos de piel y colmillo, sino hombres —escoria de los pozos de la prisión— que convirtieron las calles en un matadero. Jhon aún escucha, en el siseo de sus pulmones mecánicos, los gritos de su madre y el crujido de los huesos de su hermana bajo el peso de las vigas ardiendo. Aquella noche, Jhon Alias murió en el incendio; lo que emergió de entre los escombros fue algo distinto, algo forjado en el odio y el vapor. \\n\\n Fue Verne, el Ingeniero de Armas, quien lo encontró. Un carroñero de metales que vio en la masa calcinada de Jhon un lienzo en blanco. Día tras día, el taller de Verne olió a ungüento rancio y hierro al rojo vivo. Jhon recordaba el dolor como una marea negra que se negaba a llevárselo. Ante la inevitable podredumbre de la carne, Verne optó por el sacrilegio: sustituyó el torso devorado por planchas de acero frío y reemplazó partes quemadas mecanismos y engranajes que gimen con cada paso. \\n\\n Pero el milagro más oscuro late en el centro de su pecho. Allí donde antes hubo un corazón que amaba, ahora brilla el Ámbar de Dragón. Una gema maldita, extraída de las entrañas de dragones negros, que arde con un fuego interno perpetuo. Es esa energía la que impulsa sus miembros de metal, una llama que le recuerda, con cada latido eléctrico, que su vida le pertenece a un mineral escaso y no a su propia alma. \\n\\n Hoy, Jhon Alias camina bajo las sombras ocultando un rostro que es un mapa de cicatrices y bronce. Su ojo de metal nunca parpadea; busca proscritos con la paciencia de un verdugo. \\n\\n No busca justicia. La justicia es para los hombres que aún tienen piel que sentir. Jhon Alias busca el equilibrio de la balanza: un criminal por cada quemadura, una vida segada por cada latido del ámbar que le roba el descanso eterno. En un mundo de vapor y sombras, él es el recordatorio de que algunas deudas solo se pagan con la soga y el frío beso del plomo.', 'NULL');
INSERT INTO core.HEROES
(CODE, SPECIES_TYPE, BASE_STATS_ID, NAME, ALIAS, DESCRIPTION, PORTRAIT_IMAGE_URL)
VALUES('KASK', 'KIMA', 6, 'KASKA', 'La Mestiza', 'Kaska nació en la cubierta del Buscador, el navío de su padre, Guil Forniak, que viajaba por el continente en busca de artefactos y tesoros olvidados. Su madre, Kimari, murió cuando ella era niña, y nunca conoció las selvas de Zorniak ni las costumbres de su pueblo. Mestiza entre dos mundos, creció acompañando a su padre en templos abandonados, cuevas profundas y montañas olvidadas, aprendiendo a moverse con sigilo y a enfrentarse a lo desconocido, guiada por la obsesión de Guil por descubrir secretos que otros habían dejado atrás. \\n\\n En uno de esos templos hallaron una piedra extraordinaria. Al tocarla, parecía emitir un resplandor propio, como si guardara magia antigua y viva. Pero su hallazgo no pasó desapercibido: cientos de criaturas surgieron de la oscuridad y los obligaron a huir. En la confusión, la piedra resbaló de las manos de Guil y cayó sobre la arena del desierto: ante sus ojos, la tierra se transformó en oro. Era la piedra filosofal que tantas leyendas mencionaban. \\n\\n Cuando llegaron a la Ciudad de Bahía de Hierro para decidir qué hacer con ella, la piedra volvió a escapar de Guil y se convirtió en oro ante la mirada de viajeros y bebedores de la posada. Contrabandistas peligrosos empezaron a rondar la ciudad. Temiendo por su hija, Guil le pidió a Kaska que esperara mientras él ocultaba la piedra. La niña obedeció, pero la noche pasó, y Guil no regresó. Ni al día siguiente, ni al siguiente. Semanas después, comprendió que su padre jamás volvería. \\n\\n Kaska buscó por toda la ciudad algún rastro de él, pero nadie sabía nada. Aprendió, demasiado pronto, que hay tesoros que es mejor no descubrir, y que la búsqueda de lo desconocido puede dejar cicatrices que ningún oro puede reparar.', 'NULL');
INSERT INTO core.HEROES
(CODE, SPECIES_TYPE, BASE_STATS_ID, NAME, ALIAS, DESCRIPTION, PORTRAIT_IMAGE_URL)
VALUES('KORO', 'ENAN', 8, 'KOROCK', 'El Mata-Ogros', 'Korock abandonó las vastas galerías de Galdurheim, el mayor reino enano de la era, a los cincuenta y cinco años, apenas un niño para los suyos. Marchó junto a su familia en busca de nuevas montañas que excavar y reclamar como hogar. Tras años de travesía encontraron una cumbre al este de las Colinas Verdes, dura y rica en vetas profundas. La llamaron Duraheim, y allí levantaron una colonia próspera, forjada a golpe de pico y comercio. \\n\\n Korock creció entre muros de piedra y juramentos de acero, y pronto se unió al cuerpo protector de la montaña. Aprendió el arte de la guerra enana: disciplina, resistencia y paciencia. Con maza y escudo, él y sus hermanos repelían los ataques constantes de los pieles verdes que infestaban las colinas occidentales. Donde los enemigos confiaban en el número y la furia, los enanos respondían con formación y voluntad inquebrantable. En una de aquellas incursiones, Korock abatió a un ogro gigantesco llamado Cráneo Duro, hundiendo su maza en su testa y ganándose el nombre que lo acompañaría desde entonces: el Mata-Ogros. \\n\\n Los años trajeron riqueza… y atención indeseada. Duraheim se convirtió en un botín codiciado, pero los ataques seguían siendo torpes y mal organizados. Hasta que apareció Sorgoth el Sangra-Enanos. \\n\\n Sorgoth no era un caudillo más. Unió más de un centenar de tribus bajo su mando, asesinando a quienes se le oponían y convirtiendo hordas en un ejército. Astuto y despiadado, lanzó un ataque frontal contra las puertas de Duraheim, como dictaba la costumbre, mientras en secreto dirigía a una veintena de troles para quebrar una de las paredes de la montaña. La roca cedió tras varias embestidas, abriendo una brecha por la que la muerte se derramó como una marea. \\n\\n Cuando Korock y los protectores regresaron tras rechazar el asalto principal, la ciudad ya había caído. Las galerías estaban cubiertas de sangre y silencio. Sorgoth había masacrado a la población, incluida la familia de Korock. \\n\\n Entre los cuerpos y las ruinas, Korock juró que encontraría a Sorgoth. Que lo cazaría aunque tuviera que regar el continente entero con sangre de piel verde. Un juramento nacido demasiado tarde, pero grabado para siempre en la piedra de su corazón.', 'NULL');
INSERT INTO core.HEROES
(CODE, SPECIES_TYPE, BASE_STATS_ID, NAME, ALIAS, DESCRIPTION, PORTRAIT_IMAGE_URL)
VALUES('LION', 'KIMA', 7, 'LIONHEART', 'El Desterrado', 'LionHeart nació en Ancestra, ciudad oculta entre las Selvas de Zornak. Desde niño, su tío, miembro de la Guardia del León, lo instruyó en el combate cuerpo a cuerpo y en la caza, enseñándole a leer los silencios de la selva y la sangre de las presas. \\n\\n Adolescente aún, enfrentó a un Garriak, bestia descomunal que se alimenta de carne y terror, para salvar la vida de la princesa Zafira, hija del Rey Zagarán. La criatura segó la vida de varios guardianes, incluido su tío, pero LionHeart la venció con una lanza. El Rey, impresionado, lo incorporó a la Guardia del León, convirtiéndolo en el miembro más joven de la historia, incluso por delante del legendario Zòrtac. \\n\\n El ascenso de LionHeart despertó celos en Zòrtac, quien lo trató con dureza, a veces injusta. Pero el joven no se amilanó. Su valor y destreza lo hicieron destacar en cada combate contra piratas, criaturas salvajes y conspiradores, ganando admiración y respeto… incluso por encima de su maestro. \\n\\n Un día, el Rey confió a LionHeart y Zòrtac la protección de la princesa Zafira en un viaje hasta el templo de Leónidas, donde debía rendir culto a Tanakanóm. En el trayecto fueron emboscados por rebeldes. Tras eliminar la mayoría, Zòrtac partió en persecución de los enemigos, dejando a LionHeart al cuidado de la princesa. \\n\\n Entre la espesura y la soledad de la selva surgió un vínculo prohibido. Lo que hacían era traición: un guardián no podía emparejarse, y mucho menos con la hija del Rey. Una noche, Zòrtac los descubrió y amenazó con la muerte a ambos si LionHeart no abandonaba de inmediato la selva. \\n\\n LionHeart partió esa misma noche. Dejó atrás su hogar, su honor y el amor que nunca podría reclamar. Caminó hacia la tierra abierta como un hombre marcado, destinado a vivir con la memoria de lo perdido y el peso de sus propias decisiones.', 'NULL');
INSERT INTO core.HEROES
(CODE, SPECIES_TYPE, BASE_STATS_ID, NAME, ALIAS, DESCRIPTION, PORTRAIT_IMAGE_URL)
VALUES('MELI', 'HUMA', 3, 'MELIZA', 'La Sacerdotisa del Libro de los Muertos', 'Nació en el lecho frío de una familia sin nombre ni fortuna, en los márgenes de Moa Bi, donde los niños aprenden antes a robar que a rezar. Sus primeros años transcurrieron entre mendigos y callejones, con el estómago vacío y los ojos siempre atentos. Robaba a peregrinos y comerciantes, y cada día terminaba del mismo modo: huyendo de los guardias por las calles estrechas, con el miedo respirándole en la nuca.  \\n\\n La suerte la alcanzó durante una de esas persecuciones. La Guardia Inquebrantable la atrapó al fin y el castigo fue inmediato: la pérdida de ambas manos, sentencia habitual para los ladrones sin linaje. Ya estaba condenada cuando una sacerdotisa del templo de Raah la observó en silencio y vio en ella algo más que miseria. Por razones que Meliza jamás comprendería del todo, intercedió y la tomó como aprendiz. \\n\\n Desde entonces, su vida fue arrancada de las calles y entregada al rigor del templo. Fue instruida en las artes arcanas de Raah y puesta al servicio de la Logia del Templo de Baq, donde el conocimiento se guardaba con más celo que la fe. Allí, entre pergaminos sellados y puertas cerradas, Meliza descubrió la existencia de la Sala Prohibida del Conocimiento Arcano. \\n\\n Y la Sala la descubrió a ella. \\n\\n Entre los tomos del Claustro reposaba un artefacto de eras olvidadas: el Libro de los Muertos, un libro que no pertenecía del todo a este mundo. Al principio fue un murmullo en sueños, una voz apenas perceptible. Con el tiempo, los susurros se transformaron en gritos que no la dejaban dormir ni rezar. El Tomo la llamaba por su nombre. \\n\\n  Una noche, incapaz de resistir más, quebrantó todos los juramentos. Entró en la Sala Prohibida y tomó el libro. \\n\\n El poder la envolvió como una marea ardiente. Vio un futuro cercano donde el fuego devoraba el mundo y la luz se extinguía sin esperanza. El dolor de la visión fue insoportable; el terror, absoluto. Pero el Tomo también le ofreció algo más peligroso que el miedo: la certeza de que aquel destino podía cambiarse. \\n\\n Convencida —o tal vez engañada— de que podía impedirlo, Meliza abandonó el templo y Moa Bi esa misma noche. No hubo despedidas ni bendiciones. Solo una mujer marcada por el conocimiento prohibido, internándose en la oscuridad del mundo, decidida a detener un mal que quizá ya llevaba dentro.', 'NULL');
INSERT INTO core.HEROES
(CODE, SPECIES_TYPE, BASE_STATS_ID, NAME, ALIAS, DESCRIPTION, PORTRAIT_IMAGE_URL)
VALUES('THYR', 'QUEN', 2, 'THYREN', 'El Príncipe Esmeralda', 'La inmortalidad es una condena cuando el tiempo se mide en ausencias. \\n\\n Mucho antes de que el peso del acero descansara en su cintura, Thyren fue moldeado por las artes más refinadas de Cogniterra. Fue educado para la danza, para el saber arcano y para la diplomacia que exige un asiento en el Gran Consejo. Pero donde el joven Quendi encontró su verdadera voz no fue en los libros, sino en el silbido de la esgrima. Sobresalía entre sus iguales con una gracia insultante; su hoja era un relámpago blanco que humillaba a los maestros más veteranos. No luchaba por instinto, sino con la precisión matemática de una raza que tiene todo el tiempo del mundo para alcanzar la perfección. \\n\\n Hijo de un Gran Señor de la isla, su destino no era una corona —pues los reyes se extinguieron con los mitos— sino la responsabilidad de un asiento en el consejo gobernante. Su vida debía ser un ciclo eterno de política, música y crepúsculos sobre el Lago Esmeralda. \\n\\n Pero la tragedia no respeta linajes ni siglos de preparación. \\n\\n La noche del centenario de Siressa, su hermana menor, la persona más importante en su vida, Cogniterra ardía en celebración. El Lago Esmeralda era un espejo de fuego y color, iluminado por las luces de dragón que celebraban la pureza de la aristocracia Quendi. Cientos de nobles acudieron a ver la puesta de largo de la joya de la familia. El momento culminante, cuando Siressa debía cruzar el lago en su gondolina bajo los colores vivos de la pirotecnia, se convirtió en el nacimiento de una pesadilla. Thyren, apostado en la orilla, vio cómo la embarcación emergía de la bruma, deslizándose en un silencio sepulcral que devoraba los vítores de la multitud. \\n\\n Al tocar tierra, la gondolina no traía a la princesa, sino su manto escarlata, empapado de sangre aún tibia. \\n\\n La búsqueda fue inútil. Mientras el Consejo se ahogaba en protocolos y su padre en el silencio, Thyren oyó los rumores del Puerto Azul: un buque negro, sin nombre ni bandera, había partido aquella misma noche. \\n\\n Desafiando a los suyos, abandonó la isla y renunció a su derecho al consejo. Cambió las sedas por una armadura de placas esmeralda y la esgrima como arte por la espada como necesidad. Hoy recorre un mundo que desprecia, convertido en un cazador implacable que sigue un único rastro: la sangre escarlata de su hermana, sin importar cuántas sombras deba atravesar para hallarla.', 'NULL');
INSERT INTO core.HEROES
(CODE, SPECIES_TYPE, BASE_STATS_ID, NAME, ALIAS, DESCRIPTION, PORTRAIT_IMAGE_URL)
VALUES('VUKA', 'RUTH', 5, 'VUKANOTH', 'Hijo de la Sangre', 'Vukanoth nació en Edén, la isla maldita de los Mares de la Piratería, donde el mar huele a sal, hierro y miedo. Desde allí parten los clanes rutharis al amanecer, con velas tensas y bodegas listas para llenarse de botín, esclavos y cadáveres. Entre los elfos, los rutharis son despreciados; entre los rutharis, el clan BlodSonn es temido incluso por los suyos. \\n\\n Los BlodSonn adoran la sangre. Creen que en ella habitan la fuerza y el favor de poderes antiguos. Sus rituales los mantienen aislados en la Bahía Roja, donde cada nacimiento es marcado por un bautismo sangriento. Tras él, se hacen a la mar como el resto… pero no para comerciar en vidas, sino para desafiar a la muerte en combate y celebrar la supervivencia entre los cuerpos de sus enemigos. \\n\\n Vukanoth nació distinto. \\n\\n No veía gloria en matar sin propósito ni honor en el desperdicio. Así, abandonó la Bahía Roja y dejó atrás el mar para internarse en el continente, donde la muerte se vendía por monedas. Allí su nombre empezó a circular en susurros: frío, eficaz, infalible. Un asesino al que se acudía cuando el oro pesaba más que la culpa. \\n\\n El objetivo era un hombre rico, marcado para morir por una venganza comercial heredada de un padre rencoroso. No debía haber testigos. Vukanoth mató primero a los guardias, luego al hombre, rápido y limpio. Pero cuando la hija apareció, con el rostro empapado en lágrimas y sangre ajena, algo que nunca había conocido se alzó en su pecho. No fue miedo. No fue duda. Fue piedad. \\n\\n Y esa piedad lo condenó. \\n\\n Huyó de la ciudad sabiendo que la niña hablaría, que el contratista sería descubierto y que su reputación moriría con aquel encargo fallido. Desde entonces, ningún precio volvió a ser suficiente para borrar su error. \\n\\n Huyó sabiendo que su nombre moriría con aquel encargo. Ahora vaga lejos del mar y de la Bahía Roja, esperando un final violento a manos de alguien como él, mientras la mirada de la niña lo persigue en cada sueño, inmóvil, eterna, imposible de olvidar.', 'NULL');

INSERT INTO core.SPECIES_TYPE
(CODE, DESCRIPTION)
VALUES('ENAN', 'ENANO');

INSERT INTO core.SPECIES_TYPE
(CODE, DESCRIPTION)
VALUES('HUMA', 'HOMBRE');

INSERT INTO core.SPECIES_TYPE
(CODE, DESCRIPTION)
VALUES('KIMA', 'KIMARI');

INSERT INTO core.SPECIES_TYPE
(CODE, DESCRIPTION)
VALUES('QUEN', 'ELFO QUENDI');

INSERT INTO core.SPECIES_TYPE
(CODE, DESCRIPTION)
VALUES('RUTH', 'ELFO RÜTHARI');

INSERT INTO core.SPECIES_TYPE
(CODE, DESCRIPTION)
VALUES('SYLV', 'ELFO SYLVANTHO');

INSERT INTO core.BASE_STATS
(ID, PHYSICAL_ATTACK, MAGIC_ATTACK, EVASION, MANA, VITALITY, PHYSICAL_DEFENSE, MAGIC_DEFENSE, MOVEMENT)
VALUES(1, 3, 0, 2, 1, 3, 2, 1, 3);
INSERT INTO core.BASE_STATS
(ID, PHYSICAL_ATTACK, MAGIC_ATTACK, EVASION, MANA, VITALITY, PHYSICAL_DEFENSE, MAGIC_DEFENSE, MOVEMENT)
VALUES(2, 3, 0, 3, 2, 3, 1, 1, 2);
INSERT INTO core.BASE_STATS
(ID, PHYSICAL_ATTACK, MAGIC_ATTACK, EVASION, MANA, VITALITY, PHYSICAL_DEFENSE, MAGIC_DEFENSE, MOVEMENT)
VALUES(3, 0, 3, 2, 3, 3, 0, 2, 2);
INSERT INTO core.BASE_STATS
(ID, PHYSICAL_ATTACK, MAGIC_ATTACK, EVASION, MANA, VITALITY, PHYSICAL_DEFENSE, MAGIC_DEFENSE, MOVEMENT)
VALUES(4, 2, 1, 3, 1, 2, 1, 1, 4);
INSERT INTO core.BASE_STATS
(ID, PHYSICAL_ATTACK, MAGIC_ATTACK, EVASION, MANA, VITALITY, PHYSICAL_DEFENSE, MAGIC_DEFENSE, MOVEMENT)
VALUES(5, 4, 0, 2, 1, 2, 1, 1, 4);
INSERT INTO core.BASE_STATS
(ID, PHYSICAL_ATTACK, MAGIC_ATTACK, EVASION, MANA, VITALITY, PHYSICAL_DEFENSE, MAGIC_DEFENSE, MOVEMENT)
VALUES(6, 3, 0, 4, 0, 2, 1, 0, 5);
INSERT INTO core.BASE_STATS
(ID, PHYSICAL_ATTACK, MAGIC_ATTACK, EVASION, MANA, VITALITY, PHYSICAL_DEFENSE, MAGIC_DEFENSE, MOVEMENT)
VALUES(7, 3, 0, 2, 0, 4, 2, 1, 3);
INSERT INTO core.BASE_STATS
(ID, PHYSICAL_ATTACK, MAGIC_ATTACK, EVASION, MANA, VITALITY, PHYSICAL_DEFENSE, MAGIC_DEFENSE, MOVEMENT)
VALUES(8, 2, 0, 2, 1, 4, 3, 1, 2);

INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('DGR', 'DAGGER');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('AXE', 'AXE');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('MCE', 'MACE');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('SPR', 'SPEAR');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('BOW', 'ARCO');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('STF', 'STAFF');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('SHD', 'SHIELD');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('HGN', 'HANDGUN');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('LGN', 'LONGGUN');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('2HS', 'TWO-HANDED SWORD');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('2MC', 'TWO-HANDED MACE');
INSERT INTO core.WEAPONS_TYPE
(CODE, DESCRIPTION)
VALUES('SWD', 'SWORD');

INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('SWD', 'KASK');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('HGN', 'KASK');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('DGR', 'KASK');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('LGN', 'JHON');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('HGN', 'JHON');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('BOW', 'ELIA');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('DGR', 'ELIA');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('2MC', 'KORO');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('AXE', 'KORO');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('MCE', 'KORO');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('SPR', 'LION');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('SWD', 'LION');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('2HS', 'LION');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('STF', 'MELI');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('DGR', 'MELI');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('SWD', 'THYR');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('2HS', 'THYR');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('DGR', 'VUKA');
INSERT INTO core.HERO_SKILL_WEAPONS
(WEAPON_TYPE_CODE, HEROE_CODE)
VALUES('SWD', 'VUKA');



SET FOREIGN_KEY_CHECKS = 1;
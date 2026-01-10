SET NAMES 'utf8mb4';
SET CHARACTER SET utf8mb4;

-- =========================
-- Crear esquema
-- =========================
CREATE DATABASE IF NOT EXISTS book
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- ==========================================================
-- 1. SEGURIDAD Y USUARIOS (Añadido para aislamiento)
-- ==========================================================
-- Crear el usuario específico para el microservicio de libros
CREATE USER IF NOT EXISTS 'user_book'@'%' IDENTIFIED BY 'pass_book_123';

-- Dar permisos solo sobre la base de datos 'book'
GRANT ALL PRIVILEGES ON book.* TO 'user_book'@'%';
FLUSH PRIVILEGES;


USE book;

-- =========================
-- Tabla: SCENE_TYPES
-- =========================
CREATE TABLE SCENE_TYPES (
  CODE VARCHAR(4) NOT NULL,
  DESCRIPTION VARCHAR(255) NOT NULL,
  PRIMARY KEY (CODE)
) ENGINE=InnoDB;

-- =========================
-- Tabla: CHAPTERS
-- =========================
CREATE TABLE CHAPTERS (
  ID INT NOT NULL AUTO_INCREMENT,
  DESCRIPTION VARCHAR(255) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB;

-- =========================
-- Tabla: SCENE
-- =========================
CREATE TABLE SCENES (
  ID BIGINT NOT NULL AUTO_INCREMENT,
  NEXT_SCENE_ID BIGINT,
  SCENE_TYPE VARCHAR(4) NOT NULL,
  CHAPTER_ID INT NOT NULL,
  SCENE_TEXT TEXT NOT NULL,
  AUDIO_PATH VARCHAR(255),
  MUSIC_PATH VARCHAR(255),
  SCENE_LOCATION VARCHAR(255) NOT NULL,
  PRIMARY KEY (ID),

  CONSTRAINT fk_scene_next
    FOREIGN KEY (NEXT_SCENE_ID)
    REFERENCES SCENES(ID),

  CONSTRAINT fk_scene_type
    FOREIGN KEY (SCENE_TYPE)
    REFERENCES SCENE_TYPES(CODE),

  CONSTRAINT fk_scene_chapter
    FOREIGN KEY (CHAPTER_ID)
    REFERENCES CHAPTERS(ID)
) ENGINE=InnoDB;

-- =========================
-- Tabla: IMAGES: para centralizar archivos de imagen (Evita duplicados)
-- =========================
CREATE TABLE IMAGES (
    ID BIGINT NOT NULL AUTO_INCREMENT,
    PATH VARCHAR(255) NOT NULL,
    DESCRIPTION VARCHAR(255), -- Para saber qué imagen es (ej: "Darius Sonriendo")
    PRIMARY KEY (ID)
) ENGINE=InnoDB;

-- 2. Tabla intermedia: Secuencia de imágenes por escena
CREATE TABLE SCENE_IMAGES (
    SCENE_ID BIGINT NOT NULL,
    IMAGE_ID BIGINT NOT NULL,
    SORT_ORDER INT NOT NULL, -- campo sort
    TIME_OUT INT, -- Milisegundos para la transición
    PRIMARY KEY (SCENE_ID, SORT_ORDER),
    
    CONSTRAINT fk_si_scene
        FOREIGN KEY (SCENE_ID)
        REFERENCES SCENES(ID),
    
    CONSTRAINT fk_si_image
        FOREIGN KEY (IMAGE_ID)
        REFERENCES IMAGES(ID)
) ENGINE=InnoDB;

-- =========================
-- Tabla: DESTINATION_CHOICE_TYPES
-- =========================
CREATE TABLE DESTINATION_CHOICE_TYPES (
  CODE VARCHAR(4) NOT NULL,
  DESCRIPTION VARCHAR(255) NOT NULL,
  PRIMARY KEY (CODE)
) ENGINE=InnoDB;

-- =========================
-- Tabla: CHOICES
-- =========================
CREATE TABLE CHOICES (
  ID BIGINT NOT NULL AUTO_INCREMENT,
  SOURCE_SCENE_ID BIGINT NOT NULL,
  DESTINATION_SCENE_ID BIGINT NULL,
  CHOICE_TEXT TEXT NOT NULL,
  SORT_ORDER INT NOT NULL,
  DESTINATION_TYPE VARCHAR(4) NOT NULL,
  OBLIGATORY INT(1) NOT NULL,
  HEROE_CODE VARCHAR(4) NULL, 
  PRIMARY KEY (ID),

  CONSTRAINT fk_choice_source_scene
    FOREIGN KEY (SOURCE_SCENE_ID)
    REFERENCES SCENES(ID),

  CONSTRAINT fk_choice_destination_scene
    FOREIGN KEY (DESTINATION_SCENE_ID)
    REFERENCES SCENES(ID),

  CONSTRAINT fk_choice_destination_type
    FOREIGN KEY (DESTINATION_TYPE)
    REFERENCES DESTINATION_CHOICE_TYPES(CODE)
) ENGINE=InnoDB;

-- ==========================================================
-- INSERCIÓN DE DATOS (Ordenado por dependencias)
-- ==========================================================

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO SCENE_TYPES (CODE, DESCRIPTION) VALUES ('END', 'THE END'), ('MAIN', 'PRINCIPAL');
INSERT INTO DESTINATION_CHOICE_TYPES (CODE, DESCRIPTION) VALUES ('FGHT', 'FIGHT'), ('END', 'THE END'), ('SCEN', 'SCENE');
INSERT INTO CHAPTERS (ID, DESCRIPTION) VALUES (1, 'Capítulo I. La Roca Negra'), (999, 'Prólogo'), (9999, 'Fin');


-- Asegúrate de que tu tabla SCENES no tenga la columna IMAGE_PATH antes de ejecutar esto
-- DELETE FROM book.SCENES;

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(1, 2, 'MAIN', 999, 'Despertáis encadenados en la bodega de un barco. El suelo rezuma salitre y podredumbre. No estáis solos. Hay más cuerpos encadenados, sombras que murmuran o gimen. Los hombres de arriba hablan con acentos duros, entre risas roncas y escupitajos. Huelen a sangre, sudor seco y cuero viejo. Piratas, quizá. Traficantes de esclavos, casi seguro. Mencionan el norte, las costas de las Barbarians, la vía más rápida. Un nuevo Señor ha comenzado a pagar bien por carne viva. Y vosotros, los héroes, sois ahora mercancía. 

 La noche cae pesada y fría. El mar ruge como una bestia. Truenos golpean el cielo mientras el barco se agita, como si quisiera deshacerse de su carga. Se habla de patrullas al oeste, naves cazadoras que no tienen piedad. No hay opción: hay que adentrarse en la tormenta. 

 Entonces baja alguien de la cubierta. Va encapuchado, y la oscuridad no permite ver su rostro. La voz, sin embargo, suena clara: ha venido a revisar el producto por el que tan generosamente ha pagado. 

 Uno a uno, va pasando. 

 Debe marcaros. Su Señor exige su sello en cada cuerpo antes de poder reclamarlos. La magia que emplea es vieja y dolorosa. Quema. Mancha la piel y empaña la vista. 

 La tormenta crece. El barco se retuerce con cada embate. Las vigas gimen, los cubos de agua ruedan por la bodega, el suelo se inclina, después vuelve. El caos reina. Y entonces llega: una ola alta como una montaña. La veis por las rendijas de la madera. Un grito. Un intento de girar. Demasiado tarde. 

 El mar os traga. 

 Todo se parte, se rompe, se hunde. El agua es negra y helada. El mundo desaparece en una bocanada de espuma. 

 Y luego, nada.', NULL, NULL, 'En un barco esclavista');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(2, 3, 'MAIN', 1, 'Despertáis en la arena como cuerpos olvidados por el mar, con el gusto a sal y sangre pegado en la lengua. 

 Ninguno sabe por qué sobrevivió, ni qué precio habrá de pagar por ello. 

 El barco yace hecho pedazos a vuestro alrededor, roto como vuestras esperanzas. 

 En kilómetros de playa no hay más compañía que el sol implacable y el rumor del oleaje, y aún así, lleváis el hierro en las muñecas, grilletes que os recuerdan vuestra condición de presas, no de héroes. 

 No habláis entre vosotros, no os miráis. Tal vez penséis que en soledad hallaréis salvación. 

 Pobres necios.', NULL, NULL, '???');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(3, NULL, 'MAIN', 1, 'El engaño dura apenas unos pasos. 

 Las marcas que os dejó el encapuchado despiertan, primero con un ardor leve, luego con un dolor que os retuerce hasta las entrañas. De las heridas surge un resplandor oscuro, una cadena invisible que os une aunque lo neguéis. 

 Creísteis tener elección, pero no sois más que piezas de un juego que no comprendéis. 

 No podréis huir, no podréis separaros. Hasta romper el vínculo —si es que eso es posible— estaréis condenados a caminar juntos. Y cada dirección que elijáis no será un camino, sino una sentencia.', NULL, NULL, '???');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(4, NULL, 'MAIN', 1, ' La elección es un espejismo: todo camino lleva al mismo final. Tras kilómetros de arena, con la sed quemándoos la garganta y el hambre royéndoos las entrañas, apenas os sostenéis en pie. 

 Entonces, el silencio se rompe con cascos y acero. Una patrulla de jinetes emerge sorprendiéndoos, mirándoos como carroñeros a presa fácil 

 Jinete1: ¡Alto! ¿Quién va? ', NULL, NULL, '???');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(5, NULL, 'MAIN', 1, 'Jinete 1: Os encontráis en el Sancto Regnum. A unos kilómetros al sur se encuentra Costa Guardia y más al sur la Roca Negra, donde donde arrojamos a los piratas que naufragan ante nuestras costas. 

 ¡Piratas como vosotros! ¿Queréis agua decís? já! ¡beberéis vuestra propia sangre si no obedecéis! 

 Entregaros sin hacer tonterías', NULL, NULL, '???');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(6, NULL, 'MAIN', 1, 'Jinete 1: Os encontráis en el Sancto Regnum. A unos kilómetros al sur se encuentra Costa Guardia y más al sur la Roca Negra, donde donde arrojamos a los piratas que naufragan ante nuestras costas. 

 ¡Piratas como vosotros! Nos viene bien que llevéis grilletes, así no tendremos que maniataros. ', NULL, NULL, '???');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(7, NULL, 'MAIN', 1, 'Jinete 1: ja, ja, ja, ja 

 Miráos bien. Apenas podéis manteneros en pie. Solo sois despojos. ¿Creéis que podéis combatir contra soldados del Sancto Regnum? 

 Os doy una última oportunidad para entregaros y ser conducidos a la Roca Negra o seréis ejecutados aquí mismo. elegid:', NULL, NULL, '???');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(8, NULL, 'MAIN', 1, 'Jinete 1: Yo no tengo que decidir si sois piratas...eso será tarea del Juez de la Roca Negra. No tengo más que decir...', NULL, NULL, '???');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(9, 11, 'MAIN', 1, 'Sois arrastrados tras los jinetes durante un día entero, hasta un puerto inmenso donde se alzan galeones de guerra y mercantes abarrotados. Los soldados lo llaman Costa Guardia. Allí os entregan a otra guarnición, que os obliga a subir a una embarcación sin velas, sujeta a una cadena que lleva hasta una isla al sureste.', NULL, NULL, 'Costa Guardia');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(10, 9999, 'MAIN', 1, 'Os arrojáis al ataque, pero apenas avanzáis unos pasos antes de tropezar y desplomaros en la arena. Uno de vosotros logra erguirse frente a los jinetes, solo para ser atravesado con una lanza en medio de las carcajadas. Cae desangrándose, y lo último que escucha son las risas crueles alejándose entre cascos y polvo.', NULL, NULL, '???');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(11, 12, 'MAIN', 1, 'Horas después desembarcáis en un islote desolado. En su centro, un torreón de piedra se eleva con varios pisos de altura, coronado por cañones que vigilan el horizonte como ojos hambrientos. Sois empujados al interior entre golpes y escarnios. El patio central es un pozo de sombras: celdas inclinadas rodean el abismo, dejando ver miembros huesudos que asoman entre barrotes. Y en medio, un patíbulo improvisado: un hombre sucio y desnutrido escucha sus delitos de boca de un hombre ataviado con una gabardina blanca que sujeta un pergamino. Varios soldados preparan al condenado para su ejecución.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(12, 13, 'MAIN', 1, 'El hombre de la gabardina, al que llaman Juez, pregunta al condenado si desea pronunciar sus últimas palabras. La voz del reo tiembla: pide perdón a su familia por todo lo robado en nombre del hambre, a su madre por la deshonra y a su hijo por no… La soga se tensa antes de que termine. El cuerpo se sacude, la lengua rota inunda de sangre su boca, y su despedida se pierde en un gorgoteo. Los soldados estallan en carcajadas. Han cortado la voz del moribundo en el instante más amargo. El dolor ajeno se transforma en espectáculo. Sois situados frente al Juez. ', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(13, NULL, 'MAIN', 1, 'Juez: Dicen que os hallaron vagando sin permiso real por estas tierras… ¿Qué sois, piratas, contrabandistas, esclavistas?', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(14, 16, 'MAIN', 1, 'Juez: ¡Por supuesto! Queda aclarado todo entonces... soldados, liberen a los prisioneros. Es obvio de que se trata de un error... ', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(15, 16, 'MAIN', 1, 'Juez: Tenéis razon sir. Me disculpo en nombre de las fuerzas del reino. No podíamos correr riesgos. ¡Guardias, soltad a los prisioneros y preparenles un estofado y un buen baño de agua caliente!', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(16, 17, 'MAIN', 1, 'Sois golpeados por los guardias en la espalda y en las piernas haciéndoos caer de rodillas.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(17, 18, 'MAIN', 1, 'Juez: El delito de piratería está claro. No voy a perder el tiempo con alimañas como vosotros. Guardias, tirad el cuerpo de ese al foso y preparad a estos piratas para ser colgados.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(18, 19, 'MAIN', 1, 'Sois arrastrados entre gritos y golpes, cuando las puertas del patio se abren de nuevo. Un hombre de unos sesenta años entra, vestido con un brial blanco y dorado. Lo escoltan hombres sin camisa, cubiertos de cicatrices frescas y viejas, marcas de látigos y hierros. El juez acude a su encuentro haciendo una reverencia y besando un anillo negro y dorado de su mano. El Juez se dirige a él como Santo Inquisidor San Ilirio.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(19, 20, 'MAIN', 1, 'Juez: No le esperábamos, su santidad. ¿A qué debemos tal honor?', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(20, 21, 'MAIN', 1, 'San Ilirio: Van a traer a un prisionero que exige mi atención. Darius El Sanguinario.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(21, 22, 'MAIN', 1, 'Juez: ¡Imposible! San Ilirio: Nada es imposible bajo la protección de los Ez. Me adelanté a su escolta para que todo esté listo para el interrogatorio. —¿Y estos? Los ojos del Inquisidor se clavan en vosotros, como si ya midiera vuestra culpa.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(22, 23, 'MAIN', 1, 'Juez: Simples piratas, su santidad. No pierda el tiempo con ellos. Ahora mismo los colgaremos y prepararemos la llegada del Sanguinario El Juez hace un gesto seco; los guardias obedecen y avanzan hacia el patíbulo. Antes de que puedan apresurar el rito, un guardia irrumpe jadeando con noticias desde el muelle.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(23, 24, 'MAIN', 1, 'San Ilirio: Olvídélo. No hay tiempo. Metan a los prisioneros en una celda; ya habrá ocasión para ajusticiarlos después. Los hombres se detienen, contrariados. En lugar de la horca, sois empujados hasta una celda húmeda de la planta baja, cercana al patíbulo donde ibais a ser ahorcados apenas un minuto antes.. ', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(24, 25, 'MAIN', 1, 'Una docena de soldados entra escoltando a un hombre ensangrentado. Se trata de un hombre joven, apuesto, con melena y perilla bien cuidadas. Lo colocan frente al Inquisidor y al Juez. Los escoltas se alinean tras él, tensos, preparados para abalanzarse si hace el menor movimiento. ', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(25, 26, 'MAIN', 1, 'Darius: Bueno… ya estamos aquí. Lo dice con media sonrisa, sin apartar la mirada del Inquisidor. El Juez le cruza el rostro con un revés seco. Darius escupe sangre a un lado y vuelve a fijar sus ojos en San Ilirio, imperturbable.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(26, 27, 'MAIN', 1, 'San Ilirio: Tu bravuconería es admirable. Traicionado por los tuyos, cazado como un animal… y aún sonríes Darius: Dicen que lo último que se pierde es la sonrisa - ¿O era la esperanza?', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(27, 28, 'MAIN', 1, 'San Ilirio: Puedes renunciar a la esperanza… Tras un par de días de interrogatorio nos dirás todo lo que necesito para acabar contigo y los tuyos', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(28, 29, 'MAIN', 1, 'Una campana estalla en lo alto de la fortaleza. Los soldados se miran entre sí, inquietos. El Juez ruge, exige respuestas. Un guardia aparece jadeando: un barco del aire no identificado se lanza directo contra la Roca Negra. Los cañones retumban haciendo temblar los muros. Un impacto sacude la prisión varios pisos arriba; bloques de piedra se desploman en el patio y revientan contra el suelo. Dos soldados quedan reducidos a carne bajo los escombros. ', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(29, 30, 'MAIN', 1, 'Juez: ¡Meted al prisionero en una celda! ¡Rápido! ¡Quiero ese barco en el fondo del mar ya! (Volviéndose hacia el Inquisidor) —Santidad, debe ponerse a cubier… ', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(30, 31, 'MAIN', 1, 'La voz se quiebra. Donde estaba San Ilirio sólo queda una montaña de ruinas. Entre la roca asoma una mano con un anillo negro y dorado. El Juez ordena despejar el lugar; algunos hombres se quedan a excavar, otros os escoltan hasta una celda del patio, contigua a la del Sanguinario. El Juez desaparece tras una puerta con la mayor parte de sus hombres, dejando el aire denso de polvo, sangre y escombros', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(31, 32, 'MAIN', 1, 'La celda del Sanguinario, a diferencia de la vuestra, tiene una abertura minúscula a modo de ventana. Darius se arranca un diente, lo hace crujir entre los dedos y lo asoma al exterior. Un humo azul brota de su mano, se retuerce y asciende en una columna hacia el cielo. Tras unos segundos, vuelve a meter su mano y retrocede hasta tocar los barrotes del otro extremo de la celda con su espalda. Se gira hacia vosotros.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(32, NULL, 'MAIN', 1, 'Darius: Sí yo fuera vosotros, me apartaría de esa pared. Narrador: Dice señalando la pared exterior de vuestra celda.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(33, 9999, 'MAIN', 1, 'Desoís la advertencia y permanecéis junto al muro. Un cañonazo revienta la piedra en un estruendo brutal. El impacto os despedaza al instante. Carne y hueso cubren la celda. Vuestra historia termina aquí.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(34, 35, 'MAIN', 1, 'Hacéis caso y retrocedéis hacia la pared interior. Segundos después, el cañón revienta la muralla y abre una brecha que comunica ambas celdas. El aire se llena de polvo y cascotes. Darius avanza hasta la abertura y contempla el exterior: el barco del aire bombardea la prisión mientras sobrevuela las aguas. El Sanguinario se prepara para saltar al terreno, pero antes se gira hacia vosotros.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(35, 36, 'MAIN', 1, 'Darius: Ante vosotros se presentan dos caminos: — Podéis seguirme y escapar. Llevaréis una vida de proscritos y seréis perseguidos hasta el final de vuestros días en esta tierra... o podéis quedaros y esperar la soga. — Yo lo tengo claro. Darius se lanza al vacío y desaparece de vuestra vista.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(36, 37, 'MAIN', 1, 'Saltáis al exterior y os encontráis con Darius, quien parece haberos esperado. Él os indica que lo sigáis. El barco del aire sigue intercambiando disparos con los cañones de la prisión, aunque la distancia y la pericia del piloto evitan que los proyectiles acierten. Avanzáis unos metros y un enano de barba blanca se interpone en vuestro camino', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(37, 38, 'MAIN', 1, 'Enano: ¡Pardiez, Darius! Pensé que no saldrías con vida de ahí. Debes ser el hombre más afortunado del mundo', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(38, 39, 'MAIN', 1, 'Darius: ¡Zornak, amigo! Lo que voy a ser es el hombre más endeudado si derriban el barco de Noca. —Debemos darnos prisa antes de que reparen mi ausencia. Ese barco no aguantará mucho más — ¿Has traído armas? ', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(39, 40, 'MAIN', 1, 'Zornak: Sí. Traje todas las que pediste... aunque no sé para qué querías tantas. El enano despliega una manta: armas de todo tipo, muchas oxidadas o desgastadas, pero todas potencialmente útiles. Zornak: Por cierto, ¿Estos quienes son? Dice el enano centrando su mirada en vosotros.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(40, NULL, 'MAIN', 1, 'Darius: Digamos que... compañeros de infortunios. — Bien. Coged un arma. La necesitaremos. La distracción del cielo no durará mucho.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(41, 42, 'SPEC', 1, 'Os armáis en silencio, conscientes de que lo que viene no admite errores. El metal suena apagado, como si incluso las armas temieran el combate.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(42, 43, 'MAIN', 1, 'Zornak: Debemos darnos prisa. He ocultado una bote en el extremo sur de la isla. No tardarán en encontrarlo… o en encontrarnos a nosotros. \n\n Darius: Entonces no perdamos más tiempo.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(43, 44, 'MAIN', 1, 'Una explosión sacude los cielos. Todos alzan la vista: el barco del aire sigue intercambiando fuego con las defensas de la prisión. Su piloto maniobra con maestría, rodeando la fortaleza mientras esquiva proyectiles que arrancan trozos de piedra del torreón. \n\n Zornak: Vas a deberle una muy grande a Jok. ', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(44, 45, 'MAIN', 1, 'Un disparo certero alcanza las hélices centrales del navío. El barco se inclina hacia babor, pierde altura con rapidez y, en apenas unos segundos, se estrella contra el puerto de la prisión. La explosión levanta una columna de humo negro que ennegrece el cielo. \n\n Darius: Demasiado grande…', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(45, 46, 'MAIN', 1, 'El grupo corre junto a Darius y Zornak. Sin el barco del aire, saben que su fuga no tardará en ser descubierta. Avanzan por el flanco oriental de la isla, ocultándose entre rocas y árboles escasos. La campana de la prisión no deja de sonar. Ya los están buscando. \n\n Tras recorrer unos cientos de metros, una patrulla de guardias emerge de improviso y les corta el paso. \n\n Guardia:¡Alto! No iréis a ninguna parte, bellacos. Rendíos y moriréis con dignidad. ', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(46, 47, 'MAIN', 1, 'Darius: Me temo que no. Hoy no es el día de mi muerte. \n\n (alza el arma) \n\n -- ¡Cargad! \n\n Darius y el enano se lanzan contra los guardias. El resto se abalanza sobre los héroes. El acero choca y la huida se convierte en sangre.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(47, 48, 'FGHT', 1, '(COMBATE CONTRA 3 GUARDIAS)', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(48, 49, 'MAIN', 1, 'El suelo está empapado de sangre. Un barro espeso y oscuro cubre las piedras, y el aire huele a hierro y muerte. Darius recorre al grupo con la mirada, uno por uno, comprobando que siguen con vida. Cuando lo confirma, una sonrisa dura, casi animal, se dibuja en su rostro. Ha encontrado aliados útiles… y en tiempos como estos, eso vale más que cualquier juramento. \n\n En la distancia resuenan voces. Más guardias. Demasiados. Si se detienen, morirán rodeados. \n\n Avanzan varios cientos de metros hasta que el sendero desaparece en una pendiente que los obliga a salir a terreno abierto. No hay elección. Corren, con el corazón golpeando el pecho y plegarias mudas en los labios. Pero los dioses no escuchan. \n\n Los ven. \n\n Una lluvia de fuego y flechas cae sobre ellos, silbando en el aire como serpientes furiosas.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(49, 50, 'MAIN', 1, 'Corren hasta una gran roca que les ofrece cobertura. Fragmentos de piedra saltan a su alrededor. Darius observa el terreno: cien metros hasta alcanzar la zona rocosa que desciende hacia la costa sur de la isla. Cien metros de exposición. \n\n Darius: Solo un poco más. Iré yo primero. Iré yo primero. Si creéis en algún dios, rezadle. Yo rezaré a la suerte. \n\n Sin esperar respuesta, se lanza al descubierto. Flechas y balas muerden el suelo a su alrededor, levantando polvo y chispas. Contra toda lógica, llega al otro lado. \n\n El enano va después. Corre tras la estela de Darius con menos elegancia y muchos más gruñidos. Tropieza, rueda tras golpear una piedra y completa los últimos metros dando vueltas. Magullado y furioso, pero vivo.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(50, 51, 'GAME', 1, 'Llega vuestro turno.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(51, 52, 'MAIN', 1, 'Uno a uno, todos descienden por la escarpada ladera sur de la isla, fuera de la vista de la muralla fortificada de la prisión. \n\n Zornak: ¡Rápido! ¡El bote está cerca! \n\n El sendero es poco más que una cicatriz en la roca, estrecho y traicionero, bordeando el acantilado. Pegados a la pared, avanzan sin mirar abajo. Un paso en falso los haría caer y quedar destrozados contra las rocas del fondo. La suerte, esta vez, no los abandona.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(52, 53, 'MAIN', 1, 'Cuando por fin divisan el bote, varias figuras se interponen en su camino. \n\n Darius las reconoce de inmediato. \n\n El Juez de la prisión avanza un paso, acompañado por cuatro guardias.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(53, 54, 'MAIN', 1, 'Darius: ¿Así que no vas a dejarme en paz nunca, capitán? \n\n Juez: ¿Capitán? Dejé de ser capitán hace muchos años. Ahora soy el Juez de Roca Negra. Tu excursión termina aquí, Darius el Sanguinario. \n\n Darius escupe al suelo. \n\n Darius: Es curioso que seas tú quien me llame así. Tú, que pasaste por la espada a hombres, mujeres y niños en Puerto Triste. Dime… ¿puedes dormir después de aquello?', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(54, 55, 'MAIN', 1, 'El rostro del Juez se endurece. Sus ojos se vuelven de hielo. \n\n Juez: Esos traidores escondían bárbaros entre su propia gente. \n\n Darius: Era una familia. Huían de una tierra cruel buscando un futuro. No eran una amenaza para nadie. \n\n Juez: ¡Eran barbaros! Castigo la traición como debe castigarse. No voy a dar más explicaciones a un terrorista como tú. He mantenido la paz del Santo Regnum durante décadas… y lo haré después de tu muerte. \n\n Darius da un paso al frente. \n\n Darius: Capitán, como ya les he dicho a tus hombres… hoy no es el día de mi muerte.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(55, 56, 'MAIN', 1, 'El mundo estalla. \n\n El hacha de Zornak corta el aire y se hunde en el pecho de un guardia, atravesando carne y hueso. El segundo hacha gira con violencia imposible y derriba a otros dos antes de que puedan reaccionar. El enano ya no es el fugitivo torpe de hace un momento: ahora es la muerte en movimiento. \n\n Un guardia intenta atacarlo por la espalda. Zornak se gira por instinto y clava el hacha en su tibia. El grito es corto y atroz. El último guardia duda, preso del miedo… y muere por ello. \n\n En apenas unos segundos, los guardias yacen en el suelo, exhalando sus últimos alientos. Zornak queda frente al antiguo capitán, respirando como una bestia acorralada.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(56, 57, 'MAIN', 1, 'Juez: Ven, hereje. Daré a Gladius de beber tu sangre. \n\n Darius: ¡Zornak, espera! \n\n Demasiado tarde. \n\n El enano se lanza con furia desatada, pero el Juez esquiva el golpe con una rapidez inesperada. Un disparo ensordecedor rompe el aire. \n\n El pecho de Zornak estalla. \n\n Sangre y huesos se esparcen por la roca y la tierra, mezclándose con la sangre de los hombres que él mismo acaba de matar. \n\n Darius: ¡NOOOO! ', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(57, 58, 'MAIN', 1, 'Un hilo de humo se eleva del cañón de la pistola del Juez. Sonríe. No es triunfo, es odio satisfecho. Deja caer el arma descargada y desenvaina un sable peculiar: tiene el mango negro con detalles dorados. El mismo sable que usan en la Guardia Del Mar para matar bárbaros. \n\n Hace un gesto con la mano, invitando a Darius \n\n Darius carga con un alarido. Las espadas chocan entre las rocas. El terreno traicionero lo entorpece, mientras el Juez se mueve con una seguridad inquietante. Darius intenta flanquearlo. El Juez aprovecha ese margen para esquivarlo y Darius se precipita al espacio que antes ocupaba el Juez preso de su propia inercia. Ha cometido un error fatal. \n\n Unas boleadoras silban en el aire y se cierran sobre el torso de Darius. Cae con fuerza. Las cuerdas lo aprisionan, atrapando sus brazos.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(58, 59, 'MAIN', 1, 'Juez: Me gustaría matarte aquí mismo, pero aún hay información que sacarte. \n\n Se gira hacia vosotros, con los ojos encendidos. \n\n Juez: En cambio vosotros, no llegareis vivos al juicio.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(59, 60, 'FGHT', 1, 'Combate contra el Juez de Roca Negra', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(60, NULL, 'MAIN', 1, 'Con el Juez abatido, el grupo se apresura a desatar a Darius. Las cuerdas caen al suelo, pero él no pierde un segundo. Corre hacia el cuerpo de Zornak. \n\n El enano yace inmóvil sobre la roca, los ojos apagados, la sangre oscurecida alrededor de su cabeza destrozada. No hay aliento en su pecho. No hay furia ya. Solo silencio. \n\n Disparos de arcabuz resuenan en la distancia, secos y urgentes. Cada estampido empuja al grupo hacia el bote. Gritan. Apremian. El tiempo se agota.', NULL, NULL, 'La Roca Negra');

INSERT INTO book.SCENES (ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(9999, NULL, 'END', 9999, 'THE END', NULL, NULL, 'THE END');



/**************************************** C H O I C E S ******************************************************************************************
*****************************************               *****************************************************************************************/
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(1, 3, 4, 'Bordear la costa hacia el norte.', 1, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(2, 3, 4, 'Bordear la costa hacia el sur', 2, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(3, 3, 4, 'Adentrarse tierra adentro.', 3, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(4, 4, 5, 'Viajeros nada más. Nuestro barco naufragó con la tormenta, y ahora vagamos famélicos y sedientos. ¿Nos puedes decir donde estamos? y aún más importante, os rogamos señor, ¿acaso lleváis agua… o vino?', 1, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(5, 4, 6, 'Somos prisioneros. Esclavistas nos capturaron en tierras lejanas y la tormenta hundió su barco anoche. Despertamos aquí, sin rumbo ni memoria. Decidnos… ¿dónde estamos?', 2, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(6, 4, 7, 'No es asunto vuestro. Seguid vuestro camino y fingid que nunca nos visteis, si queréis evitar problemas', 3, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(7, 5, 8, 'Señor, no llevamos grilletes por gusto. Decimos la verdad, fuimos prisioneros de los esclavistas, no somos piratas.', 1, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(8, 5, 7, 'No somos piratas. Sabemos pelear, y no buscamos sangre; pero si nos obligáis, responderemos. No confundáis hambre y cadenas con crimen', 2, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(9, 6, 8, 'Señor, no llevamos grilletes por gusto. Decimos la verdad, fuimos prisioneros de los esclavistas, no somos piratas.', 1, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(10, 6, 7, 'No somos piratas. Sabemos pelear, y no buscamos sangre; pero si nos obligáis, responderemos. No confundáis hambre y cadenas con crimen', 2, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(11, 8, 9, 'Está bien. Nos rendimos.', 1, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(12, 7, 9, 'Está bien. Nos rendimos.', 1, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(13, 8, 10, 'No pensamos rendirnos ante nadie.  ((atacar a 7 caballeros provistos de armadura y lanzas teniendo unicamente 1 punto de salud cada jugador))', 2, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(14, 7, 10, 'No pensamos rendirnos ante nadie.  ((atacar a 7 caballeros provistos de armadura y lanzas teniendo unicamente 1 punto de salud cada jugador))', 2, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(15, 13, 14, 'Somos viajeros. Nada más. El destino nos arrojó a la bodega de un barco esclavista, pero no somos una amenaza. Solo queremos continuar nuestro camino.', 1, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(16, 13, 15, 'Ninguna de esas vilezas. Somos viajeros. ¿Así se trata en estas tierras a las víctimas de los esclavistas?', 2, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(17, 13, 15, '¿cómo osáis llamarme pirata? soy un príncipe quendi. ¡Exijo que se me libere y se me alimente como es debido!', 3, 'SCEN', 1, 'THY');
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(18, 32, 33, 'NO APARTARSE', 1, 'SCEN', 1, NULL);
INSERT INTO book.CHOICES
(ID, SOURCE_SCENE_ID, DESTINATION_SCENE_ID, CHOICE_TEXT, SORT_ORDER, DESTINATION_TYPE, OBLIGATORY, HEROE_CODE)
VALUES(19, 32, 34, 'APARTARSE', 2, 'SCEN', 1, NULL);


INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(1, '/static/image/scenes/chapter1/barco_naufragio.avif', 'Barco en el que naufragian los héroes en la playa');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(2, '/static/image/scenes/chapter1/descubre_marcas_malignas.avif', 'Mirándose las marcas de los brazos en primera persona');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(3, '/static/image/scenes/chapter1/patrulla_jinetes_costa_guardia.avif', 'Patrulla de jinetes en la playa del naufrágio');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(4, '/static/image/scenes/chapter1/jinete_patrulla_costa_guardia.avif', 'Jinete de la patrulla de jinetes en la playa del naufrágio');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(5, '/static/image/scenes/chapter1/guerrero_lanceado.avif', 'Guerrero lanceado por jinetes');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(6, '/static/image/scenes/chapter1/llegando_a_costa_guardia.avif', 'Patrulla de jinetes llegando a Costa Guardia');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(7, '/static/image/scenes/chapter1/roca_negra.avif', 'Vista de la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(8, '/static/image/scenes/chapter1/juez_con_condenado.avif', 'Juez posado al lado de condenado en la soga en la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(9, '/static/image/scenes/chapter1/juez_en_roca_negra.avif', 'Juez hablando dentro de la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(10, '/static/image/scenes/chapter1/san_ilirio_recien_llegado.avif', 'San Ilirio irrumpiendo en la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(11, '/static/image/scenes/chapter1/darius_recien_llegado.avif', 'Llega Darius a la Roca Negra escoltado por guardias');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(12, '/static/image/scenes/chapter1/san_ilirio_hablando_a_darius.avif', 'San Ilirio hablando con Darius en la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(13, '/static/image/scenes/chapter1/guardia_roca_negra_avistando_barco.avif', 'Guardia de la Roca Negra avistando Barco de Jok');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(14, '/static/image/scenes/chapter1/san_ilirio_sepultado.avif', 'San Ilirio sepultado bajo montaña de escombros');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(15, '/static/image/scenes/chapter1/bengala_diente_darius.avif', 'Darius se saca un diente y provoca una columna de humo');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(16, '/static/image/scenes/chapter1/darius_tras_barrotes.avif', 'Darius tras los barrotes de celda en la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(17, '/static/image/scenes/chapter1/celda_game_over.avif', 'Celda de los héroes destruida en un Game Over');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(18, '/static/image/scenes/chapter1/butron_en_celda.avif', 'Butrón en la celda de Darius');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(19, '/static/image/scenes/chapter1/darius_delante_butron.avif', 'Darius delante del butrón de su celda');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(20, '/static/image/scenes/chapter1/barco_jok_disparando.avif', 'Barco de Jok disparando contra la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(21, '/static/image/scenes/chapter1/enano_zornak.avif', 'Enano Zornak presentándose');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(22, '/static/image/scenes/chapter1/darius_exterior_roca_negra.avif', 'Darius en el exterior de la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(23, '/static/image/scenes/chapter1/armas_zornak_desplegadas.avif', 'Armas de Zornak desplegadas');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(24, '/static/image/scenes/chapter1/barco_jok_explotando.avif', 'Barco de Jok explotando');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(25, '/static/image/scenes/chapter1/patrulla_roca_negra.avif', 'Patrulla de la Roca Negra interponiéndose en el camino');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(26, '/static/image/scenes/chapter1/patrulla_roca_negra_derrotada.avif', 'Cadáveres de la patrulla de la Roca Negra derrotada. ');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(27, '/static/image/scenes/chapter1/bajo_disparos_en_roca_negra.avif', 'Héroes corriendo bajo fuego enemigo en la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(28, '/static/image/scenes/chapter1/sendero_acantilado_roca_negra.avif', 'Sendero que desciende por el acantilado de la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(29, '/static/image/scenes/chapter1/juez_y_patrulla_frente_a_bote.avif', 'Juez y guardias interponiéndose entre héroes y el bote');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(30, '/static/image/scenes/chapter1/darius_y_zorna_desfiladero.avif', 'Darius y Zornak hablando con Juez a los pies del desfiladero');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(31, '/static/image/scenes/chapter1/juez_frente_a_barca.avif', 'Juez frente al bote en la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(32, '/static/image/scenes/chapter1/zornak_combatiendo_guardias.avif', 'Zornak combatiendo contra guardias en la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(33, '/static/image/scenes/chapter1/darius_gritando_a_zornak.avif', 'Darius gritando que se detenga a Zornak');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(34, '/static/image/scenes/chapter1/juez_disparando_a_zornak.avif', 'Juez disparando en el pecho a Zornak');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(35, '/static/image/scenes/chapter1/juez_sonriendo.avif', 'Juez sonriendo después de disparar a Zornak');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(36, '/static/image/scenes/chapter1/duelo_darius_y_juez.avif', 'Combate entre Darius y Juez');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(37, '/static/image/scenes/chapter1/juez_con_sable.avif', 'Juez con el sable desenvainado');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(38, '/static/image/scenes/chapter1/bote_escapando_roca_negra.avif', 'Bote escapando de la Roca Negra');
INSERT INTO book.IMAGES
(ID, `PATH`, DESCRIPTION)
VALUES(39, '/static/image/scenes/chapter1/heroe_golpeado_por_guardia.avif', 'Héroe golpeado por guardia de la Roca Negra');

INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(2, 1, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(3, 2, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(4, 3, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(5, 4, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(6, 4, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(7, 4, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(8, 4, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(9, 6, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(10, 5, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(11, 7, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(12, 8, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(13, 9, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(14, 9, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(15, 9, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(16, 39, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(17, 9, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(18, 10, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(19, 9, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(20, 10, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(21, 10, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(22, 9, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(23, 10, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(24, 11, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(25, 11, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(26, 12, 1, 4);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(26, 11, 2, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(27, 12, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(28, 13, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(29, 9, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(30, 14, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(31, 15, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(32, 16, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(33, 17, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(34, 18, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(35, 19, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(36, 20, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(37, 21, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(38, 22, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(39, 23, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(40, 22, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(42, 21, 1, 4);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(42, 22, 2, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(43, 20, 1, 4);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(43, 21, 2, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(44, 24, 1, 4);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(44, 22, 2, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(45, 25, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(46, 22, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(48, 26, 1, 4);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(48, 22, 2, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(49, 27, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(51, 28, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(52, 29, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(53, 30, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(54, 31, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(55, 32, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(56, 33, 1, 4);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(56, 34, 2, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(57, 35, 1, 4);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(57, 36, 2, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(58, 37, 1, NULL);
INSERT INTO book.SCENE_IMAGES
(SCENE_ID, IMAGE_ID, SORT_ORDER, TIME_OUT)
VALUES(60, 38, 1, NULL);



SET FOREIGN_KEY_CHECKS = 1;
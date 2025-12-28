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
  IMAGE_PATH VARCHAR(255),
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


INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(1, 2, 'MAIN', 999, 'Despiertan encadenados en la bodega de un barco. El suelo rezuma salitre y podredumbre. No están solos. Hay más cuerpos encadenados, sombras que murmuran o gimen. Los hombres de arriba hablan con acentos duros, entre risas roncas y escupitajos. Huelen a sangre, sudor seco y cuero viejo. Piratas, quizá. Traficantes de esclavos, casi seguro. Mencionan el norte, las costas de las Barbarians, la vía más rápida. Un nuevo Señor ha comenzado a pagar bien por carne viva. Y ellos, los héroes, son ahora mercancía. 

 La noche cae pesada y fría. El mar ruge como una bestia. Truenos golpean el cielo mientras el barco se agita, como si quisiera deshacerse de su carga. Se habla de patrullas al oeste, naves cazadoras que no tienen piedad. No hay opción: hay que adentrarse en la tormenta. 

 Entonces baja alguien de la cubierta. Va encapuchado, y la oscuridad no permite ver su rostro. La voz, sin embargo, suena clara: ha venido a revisar el producto por el que tan generosamente ha pagado. 

 Uno a uno, va pasando. 

 Debe marcarlos. Su Señor exige su sello en cada cuerpo antes de poder reclamarlos. La magia que emplea es vieja y dolorosa. Quema. Mancha la piel y empaña la vista. 

 La tormenta crece. El barco se retuerce con cada embate. Las vigas gimen, los cubos de agua ruedan por la bodega, el suelo se inclina, después vuelve. El caos reina. Y entonces llega: una ola alta como una montaña. La ven por las rendijas de la madera. Un grito. Un intento de girar. Demasiado tarde. 

 El mar los traga. 

 Todo se parte, se rompe, se hunde. El agua es negra y helada. El mundo desaparece en una bocanada de espuma. 

 Y luego, nada.', NULL, NULL, NULL, 'En un barco esclavista');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(2, 3, 'MAIN', 1, 'Despiertan en la arena como cuerpos olvidados por el mar, con el gusto a sal y sangre pegado en la lengua. 

 Ninguno sabe por qué sobrevivió, ni qué precio habrá de pagar por ello. 

 El barco yace hecho pedazos a su alrededor, roto como sus esperanzas. 

 En kilómetros de playa no hay más compañía que el sol implacable y el rumor del oleaje, y aún así, llevan el hierro en las muñecas, grilletes que les recuerdan su condición de presas, no de héroes. 

 No hablan entre sí, no se miran. Tal vez piensen que en soledad hallarán salvación. 

 Pobres necios.', NULL, NULL, NULL, '???');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(3, NULL, 'MAIN', 1, 'El engaño dura apenas unos pasos. 

 Las marcas que les dejó el encapuchado despiertan, primero con un ardor leve, luego con un dolor que les retuerce hasta las entrañas. De las heridas surge un resplandor oscuro, una cadena invisible que los une aunque lo nieguen. 

 Creyeron tener elección, pero no son más que piezas de un juego que no comprenden. 

 No podrán huir, no podrán separarse. Hasta romper el vínculo —si es que eso es posible— estarán condenados a caminar juntos. Y cada dirección que elijan no será un camino, sino una sentencia.', NULL, NULL, NULL, '???');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(4, NULL, 'MAIN', 1, ' La elección es un espejismo: todo camino lleva al mismo final. Tras kilómetros de arena, con la sed quemándoles la garganta y el hambre royéndoles las entrañas, apenas se sostienen en pie. 

 Entonces, el silencio se rompe con cascos y acero. Una patrulla de jinetes emerge sorprendiéndoles, mirándolos como carroñeros a presa fácil 

 Jinete1: ¡Alto! ¿Quién va? ', NULL, NULL, NULL, '???');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(5, NULL, 'MAIN', 1, 'Jinete 1: Os encontráis en el Sancto Regnum. A unos kilómetros al sur se encuentra Costa Guardia y más al sur la Roca Negra, donde donde arrojamos a los piratas que naufragan ante nuestras costas. 

 ¡Piratas como vosotros! ¿Queréis agua decís? já! ¡beberéis vuestra propia sangre si no obedecéis! 

 Entregaros sin hacer tonterías', NULL, NULL, NULL, '???');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(6, NULL, 'MAIN', 1, 'Jinete 1: Os encontráis en el Sancto Regnum. A unos kilómetros al sur se encuentra Costa Guardia y más al sur la Roca Negra, donde donde arrojamos a los piratas que naufragan ante nuestras costas. 

 ¡Piratas como vosotros! Nos viene bien que llevéis grilletes, así no tendremos que maniataros. ', NULL, NULL, NULL, '???');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(7, NULL, 'MAIN', 1, 'Jinete 1: ja, ja, ja, ja 

 Miráos bien. Apenas podéis manteneros en pie. Solo sois despojos. ¿Creéis que podéis combatir contra soldados del Sancto Regnum? 

  Os doy una última oportunidad para entregaros y ser conducidos a la Roca Negra o seréis ejecutados aquí mismo. elegid:', NULL, NULL, NULL, '???');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(8, NULL, 'MAIN', 1, 'Jinete 1: Yo no tengo que decidir si sois piratas...eso será tarea del Juez de la Roca Negra. No tengo más que decir...', NULL, NULL, NULL, '???');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(9, NULL, 'MAIN', 1, 'El grupo es arrastrado tras los jinetes durante un día entero, hasta un puerto inmenso donde se alzan galeones de guerra y mercantes abarrotados. Los soldados lo llaman Costa Guardia. Allí los entregan a otra guarnición, que los obliga a subir a una embarcación sin velas, sujeta a una cadena que lleva hasta una isla al sureste.', NULL, NULL, NULL, 'Costa Guardia');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(10, 9999, 'MAIN', 1, 'Se arrojan al ataque, pero apenas avanzan unos pasos antes de tropezar y desplomarse en la arena. Uno logra erguirse frente a los jinetes, solo para ser atravesado con una lanza en medio de las carcajadas. Cae desangrándose, y lo último que escucha son las risas crueles alejándose entre cascos y polvo.', NULL, NULL, NULL, '???');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(11, 12, 'MAIN', 1, 'Horas después desembarcan en un islote desolado. En su centro, un torreón de piedra se eleva con varios pisos de altura, coronado por cañones que vigilan el horizonte como ojos hambrientos. Los prisioneros son empujados al interior entre golpes y escarnios. El patio central es un pozo de sombras: celdas inclinadas rodean el abismo, dejando ver miembros huesudos que asoman entre barrotes. Y en medio, un patíbulo improvisado: un hombre sucio y desnutrido escucha sus delitos de boca de un hombre ataviado con una toga negra que sujeta un pergamino. Varios soldados preparan al condenado para su ejecución.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(12, 13, 'MAIN', 1, 'El hombre de la toga, al que llaman Juez, pregunta al condenado si desea pronunciar sus últimas palabras. La voz del reo tiembla: pide perdón a su familia por todo lo robado en nombre del hambre, a su madre por la deshonra y a su hijo por no… La soga se tensa antes de que termine. El cuerpo se sacude, la lengua rota inunda de sangre su boca, y su despedida se pierde en un gorgoteo. Los soldados estallan en carcajadas. Han cortado la voz del moribundo en el instante más amargo. El dolor ajeno se transforma en espectáculo. Los protagonistas son situados frente al Juez. ', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(13, NULL, 'MAIN', 1, 'Juez: Dicen que os hallaron vagando sin permiso real por estas tierras… ¿Qué sois, piratas, contrabandistas, esclavistas?', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(14, 16, 'MAIN', 1, 'Juez: ¡Por supuesto! Queda aclarado todo entonces... soldados, liberen a los prisioneros. Es obvio de que se trata de un error... ', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(15, 16, 'MAIN', 1, 'Juez: Tenéis razon sir. Me disculpo en nombre de las fuerzas del reino. No podíamos correr riesgos. ¡Guardias, soltad a los prisioneros y preparenles un estofado y un buen baño de agua caliente!', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(16, 17, 'MAIN', 1, 'Los prisioneros son golpeados por los guardias en la espalda y en las piernas haciéndoles caer de rodillas.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(17, 18, 'MAIN', 1, 'Juez: El delito de piratería está claro. No voy a perder el tiempo con alimañas como vosotros. Guardias, tirad el cuerpo de ese al foso y preparad a estos piratas para ser colgados.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(18, 19, 'MAIN', 1, 'Los prisioneros son arrastrados entre gritos y golpes, cuando las puertas del patio se abren de nuevo. Un hombre de unos sesenta años entra, vestido con un brial blanco y dorado. Lo escoltan hombres sin camisa, cubiertos de cicatrices frescas y viejas, marcas de látigos y hierros. El juez acude a su encuentro haciendo una reverencia y besando un anillo negro y dorado de su mano. El Juez se dirige a él como Santo Inquisidor San Ilirio.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(19, 20, 'MAIN', 1, 'Juez: No le esperábamos, su santidad. ¿A qué debemos tal honor?', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(20, 21, 'MAIN', 1, 'San Ilirio: Van a traer a un prisionero que exige mi atención. Darius El Sanguinario.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(21, 22, 'MAIN', 1, 'Juez: ¡Imposible!  San Ilirio: Nada es imposible bajo la protección de los Ez. Me adelanté a su escolta para que todo esté listo para el interrogatorio. —¿Y estos?  Los ojos del Inquisidor se clavan en los prisioneros, como si ya midiera su culpa.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(22, 23, 'MAIN', 1, 'Juez: Simples piratas, su santidad. No pierda el tiempo con ellos. Ahora mismo los colgaremos y prepararemos la llegada del Sanguinario      El Juez hace un gesto seco; los guardias obedecen y avanzan hacia el patíbulo. Antes de que puedan apresurar el rito, un guardia irrumpe jadeando con noticias desde el muelle.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(23, 24, 'MAIN', 1, 'San Ilirio: Olvídélo. No hay tiempo. Metan a los prisioneros en una celda; ya habrá ocasión para ajusticiarlos después.  Los hombres se detienen, contrariados. En lugar de la horca, los prisioneros son empujados hasta una celda húmeda de la planta baja, cercana al patíbulo donde iban a ser ahorcados apenas un minuto antes.. ', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(24, 25, 'MAIN', 1, 'Una docena de soldados entra escoltando a un hombre engrilletado de pies y manos. Es de mediana edad, rapado, con una barba negra y grasienta. Una cicatriz parte su rostro en dos.  Lo colocan frente al Inquisidor y al Juez. Los escoltas se alinean tras él, tensos, preparados para abalanzarse si hace el menor movimiento. ', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(25, 26, 'MAIN', 1, 'Darius: Bueno… ya estamos aquí.   Lo dice con media sonrisa, sin apartar la mirada del Inquisidor. El Juez le cruza el rostro con un revés seco. Darius escupe sangre a un lado y vuelve a fijar sus ojos en San Ilirio, imperturbable.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(26, 27, 'MAIN', 1, 'San Ilirio: Tu bravuconería es admirable. Traicionado por los tuyos, cazado como un animal… y aún sonríes   Darius: Dicen que lo último que se pierde es la sonrisa   - ¿O era la esperanza?', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(27, 28, 'MAIN', 1, 'San Ilirio: Puedes renunciar a la esperanza… Tras un par de días de interrogatorio nos dirás todo lo que necesito para acabar contigo y los tuyos', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(28, 29, 'MAIN', 1, 'Una campana estalla en lo alto de la fortaleza. Los soldados se miran entre sí, inquietos. El Juez ruge, exige respuestas. Un guardia aparece jadeando: un barco del aire no identificado se lanza directo contra la Roca Negra. Los cañones retumban haciendo temblar los muros.   Un impacto sacude la prisión varios pisos arriba; bloques de piedra se desploman en el patio y revientan contra el suelo. Dos soldados quedan reducidos a carne bajo los escombros. ', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(29, 30, 'MAIN', 1, 'Juez: ¡Meted al prisionero en una celda! ¡Rápido! ¡Quiero ese barco en el fondo del mar ya!  (Volviéndose hacia el Inquisidor)   —Santidad, debe ponerse a cubier…    ', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(30, 31, 'MAIN', 1, 'La voz se quiebra. Donde estaba San Ilirio sólo queda una montaña de ruinas. Entre la roca asoma una mano con un anillo negro y dorado. El Juez ordena despejar el lugar; algunos hombres se quedan a excavar, otros escoltan al prisionero hasta una celda del patio, contigua a la de los supuestos piratas.   El Juez desaparece tras una puerta con la mayor parte de sus hombres, dejando el aire denso de polvo, sangre y escombros', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(31, 32, 'MAIN', 1, 'La celda del Sanguinario, a diferencia de la de los piratas, tiene una abertura minúscula a modo de ventana. Darius se arranca un diente, lo hace crujir entre los dedos y lo asoma al exterior. Un humo azul brota de su mano, se retuerce y asciende en una columna hacia el cielo.     Tras unos segundos, vuelve a meter su mano y retrocede hasta tocar los barrotes del otro extremo de la celda con su espalda. Se gira hacia los prisioneros de la celda contigua.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(32, NULL, 'MAIN', 1, 'Darius: Sí yo fuera vosotros, me apartaría de esa pared.    Narrador: Dice señalando la pared exterior de la celda de los prisioneros.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(33, 9999, 'MAIN', 1, 'Los prisioneros desoyen la advertencia y permanecen junto al muro. Un cañonazo revienta la piedra en un estruendo brutal. El impacto los despedaza al instante. Carne y hueso cubren la celda. Su historia termina aquí.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(34, 35, 'MAIN', 1, 'Los prisioneros hacen caso y retroceden hacia la pared interior. Segundos después, el cañón revienta la muralla y abre una brecha que comunica ambas celdas. El aire se llena de polvo y cascotes.   Darius avanza hasta la abertura y contempla el exterior: el barco del aire bombardea la prisión mientras sobrevuela las aguas. El Sanguinario se prepara para saltar al terreno, pero antes se gira hacia ellos.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(35, 36, 'MAIN', 1, 'Darius: Ante vosotros se presentan dos caminos:    — Podéis seguirme y escapar. Llevaréis una vida de proscritos y seréis perseguidos hasta el final de vuestros días en esta tierra... o podéis quedaros y esperar la soga.   — Yo lo tengo claro.    Darius se lanza al vacío y desaparece de su vista.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(36, 37, 'MAIN', 1, 'Los prisioneros saltan al exterior y se encuentran con Darius, quien parece haberlos esperado. Él les indica que lo sigan.   El barco del aire sigue intercambiando disparos con los cañones de la prisión, aunque la distancia y la pericia del piloto evitan que los proyectiles acierten.   Avanzan unos metros y un enano de barba blanca se interpone en su camino', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(37, 38, 'MAIN', 1, 'Enano-Prisión: ¡Pardiez, Darius! Pensé que no saldrías con vida de ahí. Debes ser el hombre más afortunado del mundo', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(38, 39, 'MAIN', 1, 'Darius: Lo que voy a ser es el hombre más endeudado si derriban el barco de Noca.  —Debemos darnos prisa antes de que reparen mi ausencia. Ese barco no aguantará mucho más    — ¿Has traído armas? ', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(39, 40, 'MAIN', 1, 'Enano-Prisión: Sí. Traje todas las que pediste... aunque no sé para qué querías tantas.  El enano despliega una manta: armas de todo tipo, muchas oxidadas o desgastadas, pero todas potencialmente útiles.    Enano-Prisión: Por cierto, ¿Estos quienes son?   Dice el enano centrando su mirada en los prisioneros que acompañan a Darius.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(40, NULL, 'MAIN', 1, 'Darius: Digamos que... compañeros de infortunios.   — Bien. Coged un arma. La necesitaremos. La distracción del cielo no durará mucho.', NULL, NULL, NULL, 'La Roca Negra');
INSERT INTO book.SCENES
(ID, NEXT_SCENE_ID, SCENE_TYPE, CHAPTER_ID, SCENE_TEXT, IMAGE_PATH, AUDIO_PATH, MUSIC_PATH, SCENE_LOCATION)
VALUES(9999, NULL, 'END', 9999, 'THE END', NULL, NULL, NULL, 'THE END');

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



SET FOREIGN_KEY_CHECKS = 1;
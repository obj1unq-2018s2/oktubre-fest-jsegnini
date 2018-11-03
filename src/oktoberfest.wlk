
class Carpa {
	const limite // numero
	var property hayBanda // es booleano
	var property marcaQueVende // es una instancia de Marca
	var personasDentro = [] // lista de personas que entraron
	method cantPersonasDentro() {
		return personasDentro.size()
	}
	
	method limite() {return limite}
	method venderJarra(litros) {
		return new Jarra(capacidad=litros, marca=marcaQueVende)
	}
	method dejaEntrar(persona){
		return not persona.estaEbria() and 
		not self.cantPersonasDentro() + 1 >= self.limite()
	}
	method agregarPersona(persona){
		personasDentro.add(persona)
	}
	
	method estaEnCarpa(persona){
		return personasDentro.contains(persona)
	}
	
	method cuantosEbriosEmpedernidos(){
		return personasDentro.map({pers => pers.esEbrioEmpedernido()}).size()
	}
	
}

class Jarra {
	const property capacidad // numero (litros)
	const marca //es una instancia de Marca
	method marca() {return marca}
	
	method contAlcohol() {
		return capacidad * marca.graduacion()
	}
}

class Persona {
	const property peso // numero (gramos)
	var property jarrasCompradas = [] // lista de jarras
	var property gustaMusica //devuelve booleano
	const property aguante // numero
	method nacionalidad()
	method cuantoAlcoholIngirio() {
		return jarrasCompradas.map({jarra => jarra.contAlcohol()}).sum()
	}
	method estaEbria() {return self.cuantoAlcoholIngirio() * peso > aguante }
	method leGustaCerveza(marca){return true}
	
	
	method comprarJarra(carpa, litros){
		if (carpa.estaEnCarpa(self)) {
			jarrasCompradas.add(carpa.venderJarra(litros))
		}
	}
	
	method quiereEntrar(carpa){
		return self.leGustaCerveza(carpa.marcaQueVende()) and
		self.gustaMusica() == carpa.hayBanda()
	}
	method puedeEntrar(carpa){
		return self.quiereEntrar(carpa) and
		carpa.dejaEntrar(self)
	}
	method entrarCarpa(carpa){
		if (self.puedeEntrar(carpa)){
			carpa.agregarPersona(self)
		}
		else {"No puede ingresar a la carpa"}
	}
	method esEbrioEmpedernido(){
		return jarrasCompradas.all({jarra => jarra.capacidad() >= 1})
	}
	method esPatriota() {
		return jarrasCompradas.all({jarra => jarra.marca().pais() == self.nacionalidad()})
	}
	
}

class Aleman inherits Persona {
	override method nacionalidad() {return "Alemania"}
	override method quiereEntrar(carpa){
		return super(carpa) and (carpa.cantPersonasDentro() % 2 == 0)
	}
}

class Belga inherits Persona {
	override method nacionalidad() {return "Belgica"}
	override method leGustaCerveza(marca){
		return marca.lupulo() > 4
	}
}

class Checo inherits Persona {
	override method nacionalidad() {return "Rep. Checa"}
	override method leGustaCerveza(marca){
		return marca.graduacion() > 0.08
	}
}

class Marca {
	const pais // string. puede ser "Alemania", "Belgica" o "Rep. Checa"
	const lupulo // numero. Gramos por litro
	method pais() {return pais}
	method lupulo() {return lupulo}
}

object graduacionReglamentaria {
	method valor() {return 0.1}
}

class Rubia inherits Marca {
	const graduacion // porcentaje. valor entre 0 y 0.99
	method graduacion() {return graduacion}
}

class Negra inherits Marca {
	method graduacion() {return graduacionReglamentaria.valor().min(lupulo * 2)}
}

class Roja inherits Negra {
	override method graduacion() {return super() * 1.25}
}

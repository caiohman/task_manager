const car = class {
  cpf;

  constructor(cpf) {
    this.cpf = cpf;
  }

  async getCarInformation() {
    await fetch("http://localhost:8090/listcar", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ cpf: this.cpf }),
    })
      .then((response) => response.json())
      .then((json) => console.log(json))
      .catch((error) => this.getUserError(error));
  }
};

export default car;

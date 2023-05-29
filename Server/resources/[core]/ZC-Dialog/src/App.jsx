import React from 'react'
import './styles/dialog.css'
import logo from './assets/logo.png'
import $ from 'jquery'

class App extends React.Component {
  state = { title: 'Introduce tu mensaje' }
  
  handleKey = (key) => {
    if (key.which === 27) {
      $(".main-div").fadeOut(500)
      $.post("https://ZC-Dialog/post", JSON.stringify({
        text: $(".code-intr").val()
      }))
      $.post("https://ZC-Dialog/close")
    } else if (key.which === 13) {
      $(".main-div").fadeOut(500)
      $.post("https://ZC-Dialog/post", JSON.stringify({
        text: $(".code-intr").val()
      }))
      $.post("https://ZC-Dialog/close")
    }
  }

  componentDidMount() {
    $(".main-div").hide()
    window.addEventListener("keydown", this.handleKey)
    window.addEventListener("message", (event) => {
      if (event.data.open) {
        $("input[type=text").val("")
        this.setState({title: event.data.title})
        $(".main-div").fadeIn(500)
        $(".code-intr").focus()
      } else if (event.data.open) {
        $(".main-div").fadeOut(500)
        $.post("https://ZC-Dialog/post", JSON.stringify({
          text: $(".code-intr").val()
        }))
        $.post("https://ZC-Dialog/close")
      }
    })
    $(".accept-button").on("click", function() {
      $(".main-div").fadeOut(500)
      $.post("https://ZC-Dialog/post", JSON.stringify({
        text: $(".code-intr").val()
      }))
      $.post("https://ZC-Dialog/close")
    })
    $(".cancel-button").on("click", function() {
      $(".main-div").fadeOut(500)
      $.post("https://ZC-Dialog/close")
    })
  }

  render() {
    return (
      <div className="main-div">
        <img className="logo-wave" src={logo}/>
        <span className="span-title">{this.state.title}</span>
        <input type="text" className="code-intr" placeholder="Tu mensaje"></input>
        <div className="accept-button">
          <span className="accept-class">Aceptar</span>
        </div>
        <div className="cancel-button">
        <span className="cancel-class">Cancelar</span>
        </div>
      </div>
    )
  }
}

export default App;
